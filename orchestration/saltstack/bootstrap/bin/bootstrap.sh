#!/bin/bash
#
# Bootstraps a NetWitness node (run with --help for usage).
#
SCRIPT_HOME="$(dirname $0)/.."

# source external build properties (if available)
[ -f ${SCRIPT_HOME}/configuration/build.properties ] \
  && source ${SCRIPT_HOME}/configuration/build.properties

BLKDEV_DETECT=$(blkid | grep '"OEMDRV"\|"CentOS 7 x86_64"')
BLKDEV_NUM=$(blkid | grep -c '"OEMDRV"\|"CentOS 7 x86_64"')

# define constants
declare -r BOOTSTRAP_REPO=/opt/rsa/platform/bootstrap-repo
declare -r DESCRIPTOR_HOME=/opt/rsa/platform/nw-comp-descriptor-parser
declare -r COOKBOOK_HOME=/opt/rsa/platform/nw-chef
declare -r MINION_CONFIG=/etc/salt/minion
declare -r ORCH_CLI_HOME=/opt/rsa/platform/nw-orchestration-cli

declare -r NW_REPO=/var/lib/netwitness/common/nwrpmrepo
declare -r NW_REPO_URL_PATH=/nwrpmrepo

declare -r DVD_MOUNT_POINT=/mnt/nw-dvd
declare -r USB_MOUNT_POINT=/mnt/nw-usb

# comp descriptor property names (for -p parameters)
declare -r NW_REPO_URL_PROP_NAME=nw-repositories.repos.rsanw.baseurl
declare -r NW_REPO_SSL_VERIFY_PROP_NAME=nw-repositories.repos.rsanw.sslverify
declare -r NW_PKI_SS_CLIENT_USERID_PROP_NAME=nw-pki.ss_client.userid
declare -r NW_PKI_SS_CLIENT_PASSWORD_PROP_NAME=nw-pki.ss_client.password
declare -r NW_PKI_SS_CLIENT_HTTP_FALLBACK_PROP_NAME=nw-pki.ss_client.http_fallback
declare -r GLOBAL_HOST_ID_PROP_NAME=host.id

# ---------------------------------------------------
# echoMessage
#   ${1}: message level (DEBUG|INFO|WARN|ERROR)
#   ${2}: message text
# ---------------------------------------------------
echoMessage() {
    local messageLevel=${1}
    local messageText=${2}

    local timestamp=$(date +'%Y-%m-%dT%H:%M:%S%:z')
    local formattedMessage="[${timestamp}] <$$> (${messageLevel}) ${messageText}"
    
    # write to stdout/stderr
    case "${messageLevel}" in
        ERROR | WARN)
            echo "${formattedMessage}" >&2
            ;;
        DEBUG)
            [ ! -z "${VERBOSE}" ] && echo "${formattedMessage}"
            ;;
        USAGE)
            echo "${messageText}" >&2
            ;;
        *)
            echo "${formattedMessage}"
            ;;
    esac

    # write to log file
    if [ "${messageLevel}" != "DEBUG" -o ! -z "${VERBOSE}" ]; then
        [ ! -z "${LOG_FILE}" ] && echo "${formattedMessage}" 2>/dev/null >> ${LOG_FILE}
    fi
}

# ---------------------------------------------------
# echoUsage
#   ${1}: message text
# ---------------------------------------------------
echoUsage() {
    echoMessage USAGE "${1}"
}

# ---------------------------------------------------
# echoDebug
#   ${1}: message text
# ---------------------------------------------------
echoDebug() {
    echoMessage DEBUG "${1}"
}

# ---------------------------------------------------
# echoInfo
#   ${1}: message text
# ---------------------------------------------------
echoInfo() {
    echoMessage INFO "${1}"
}

# ---------------------------------------------------
# echoWarn
#   ${1}: message text
# ---------------------------------------------------
echoWarn() {
    echoMessage WARN "${1}"
}

# ---------------------------------------------------
# echoError
#   ${1}: message text
# ---------------------------------------------------
echoError() {
    echoMessage ERROR "${1}"
}

# ---------------------------------------------------
# exitError
#   ${1}: error text
# ---------------------------------------------------
exitError() {
    echoError "${1}"
    exit 1
}

# ---------------------------------------------------
# exitUsage
#   ${1}: error text
# ---------------------------------------------------
exitUsage() {
    echoUsage "$(basename ${0}): ${1}"
    echoUsage "Try '$(basename ${0}) --help' for usage information."
    exit 1
}

# ---------------------------------------------------
# usage
# ---------------------------------------------------
usage() {
    echoUsage "Usage:"
    echoUsage " $(basename ${0}) command [options]"
    echoUsage ""
    echoUsage "Commands:"
    echoUsage " -z, --node-zero            Bootstrap a node-zero"
    echoUsage " -x, --node-x               Bootstrap a node-x"
    echoUsage ""
    echoUsage "Options:"
    echoUsage " -a, --zero-host <host-ip>         Set node-zero host ip address"
    echoUsage " -k, --superuser-password <passwd> Set security server superuser password"
    echoUsage " -i, --node-id <id>                Set custom node identity"
    echoUsage " -l, --log-file <path>             Set log path (default: ./bootstrap.log)"
    echoUsage " -v, --verbose                     Enable verbose output"
    echoUsage " -g, --generate-uuid               Auto generate a random node identity"
    echoUsage " -d, --dev-mode                    Use latest available descriptor packages"
    echoUsage " -c, --category <name>             Override for the default descriptor category"
    echoUsage " -m, --mount-path <path>           Specify NW Yum repository mountpoint path"
    echoUsage " -r, --repo-url <repo-url>         Specify NW Yum repository url"
    echoUsage " -p, --property <envParam>         Optional environment attribute in the"
    echoUsage "                                   form of <name>=<value> Can provide multiple"
    echoUsage "                                   parameters, ex: -p param1=value1 -p param2=value2"
    echoUsage ""
    exit 1
}

# ---------------------------------------------------
# checkSystem
# ---------------------------------------------------
checkSystem() {
    # verify root/sudo user is calling script
    [ "${EUID}" -eq 0 ] || exitError "Bootstrap requires root privileges."

    # verify operating system
    if [ ! -f /etc/os-release ]; then
        exitError "Unable to determine operating system version. Missing /etc/os-release."
    fi

    local osName=$(sed -n 's/^NAME="\(.*\)"/\1/p' /etc/os-release)
    local osVersion=$(sed -n 's/^VERSION_ID="\(.*\)"/\1/p' /etc/os-release)

    if [ "${osName}" != "CentOS Linux" -o "${osVersion}" != "7" ]; then
        exitError "Platform ${osName} version ${osVersion} not supported."
    fi

    # verify we can write to logs
    touch ${LOG_FILE} >/dev/null 2>&1 \
        || exitError "Could not write logs: '${LOG_FILE}'"

    # verify bootstrap repo exists
    if [ ! -d ${BOOTSTRAP_REPO} ]; then
        exitError "Bootstrap repository missing: '${BOOTSTRAP_REPO}'"
    fi
}

# ---------------------------------------------------
# addHostEntry
#   ${1}: node type [node-zero|node-x]
#   ${2}: node zero IP address
# ---------------------------------------------------
addHostEntry() {
    local nodeType=${1}
    local nodeZeroIP=${2}
    local hostOutput=$(cat /etc/hosts | grep 'nw-node-zero')
    
    if [ -z "$hostOutput" ]; then
        if [ ${nodeType} == "node-zero" ]; then
            # append nw-node-zero to 127.0.0.1 entry in /etc/hosts
            origHostEntry=$(grep -m 1 '127.0.0.1' /etc/hosts)
            updatedHostEntry="${origHostEntry} nw-node-zero"
            sed -i "s/${origHostEntry}/${updatedHostEntry}/" /etc/hosts
        else  #node-x
            # verify nodeZeroIP is valid
            if [[ ! $nodeZeroIP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                exitError "Node Zero IP address is not a valid IP address: '${nodeZeroIP}'"
            fi
            # add nw-node-zero entry to /etc/hosts
            echo "$nodeZeroIP    nw-node-zero" >> /etc/hosts
        fi    
    fi
}

addNWRepoProperties() {
    # add repo properties
    if [ -z "${NW_REPO_URL}" ]; then
        if [ -z "${IS_MASTER}" ] && [ ! -z "${BLKDEV_DETECT}" ]; then # node-x and on hardware only
            PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_URL_PROP_NAME}=https://${ADMIN_HOST}${NW_REPO_URL_PATH}")
            echoInfo "Pointing node-x yum repo to https://${ADMIN_HOST}${NW_REPO_URL_PATH}"
        fi
    else
        PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_URL_PROP_NAME}=${NW_REPO_URL}")
    fi

    # add repo ssl disable property if specified
    if [ ! -z "${DISABLE_SSL_VERIFY}" ]; then 
        PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_SSL_VERIFY_PROP_NAME}=false")
    fi
}

usb_media() {
  echoInfo "Installing local repo from USB media"
  usb_dev=${1%?}
  if [ ! -d "${USB_MOUNT_POINT}" ]; then
      mkdir ${USB_MOUNT_POINT}
      if [ ! -d "${DVD_MOUNT_POINT}" ]; then
          mkdir -p ${DVD_MOUNT_POINT}
      fi
      mount ${usb_dev} ${USB_MOUNT_POINT} || exitError "Unable to mount ${usb_dev}"
      iso_file=$(ls -t1 ${USB_MOUNT_POINT}/*.iso 2>/dev/null | head -1)
      if [ -z "${iso_file}" ]; then
          exitError "Unable to find iso file in ${USB_MOUNT_POINT}"
      fi
      echoInfo "Found USB ISO: ${iso_file}"
      mount -o loop ${iso_file} ${DVD_MOUNT_POINT} \
          || exitError "Unable to mount ${iso_file}"

      echoInfo "Copying files to local repo"
      cp -r ${DVD_MOUNT_POINT}/Packages "${NW_REPO}/Packages" \
          || exitError "Unable to copy rpms from ${DVD_MOUNT_POINT}/Packages to ${NW_REPO}/Packages"
      cp -r ${DVD_MOUNT_POINT}/repodata "${NW_REPO}/repodata" \
          || exitError "Unable to copy repodata from ${DVD_MOUNT_POINT}/repodata to ${NW_REPO}/repodata"
      umount ${DVD_MOUNT_POINT} || exitWarn "Unable to unmount ${DVD_MOUNT_POINT}"
      umount ${USB_MOUNT_POINT} || exitWarn "Unable to unmount ${USB_MOUNT_POINT}"
      rm -rf ${DVD_MOUNT_POINT} || exitWarn "Unable to delete ${DVD_MOUNT_POINT}"
      rm -rf ${USB_MOUNT_POINT} || exitWarn "Unable to delete ${USB_MOUNT_POINT}"
      echoInfo "Local repo created from USB media"
   fi
}

dvd_media() {
    echoInfo "Installing local repo from DVD media"
    dvd_dev=${1%?}
    if [ ! -d "${DVD_MOUNT_POINT}" ]; then
      mkdir -p ${DVD_MOUNT_POINT}
    fi
    mount ${dvd_dev} ${DVD_MOUNT_POINT} || exitError "Unable to mount ${dvd_dev}"
    echoInfo "Copying files to local repo"
    cp -r ${DVD_MOUNT_POINT}/Packages "${NW_REPO}/Packages" \
        || exitError "Unable to copy rpms from /mnt/nw-dvd/Packages to ${NW_REPO}/Packages"
    cp -r ${DVD_MOUNT_POINT}/repodata "${NW_REPO}/repodata" \
        || exitError "Unable to copy repodata from ${DVD_MOUNT_POINT}/repodata to ${NW_REPO}/repodata"
    umount ${DVD_MOUNT_POINT} || exitWarn "Unable to unmount ${DVD_MOUNT_POINT}"
    rm -rf ${DVD_MOUNT_POINT} || exitWarn "Unable to delete ${DVD_MOUNT_POINT}"
    echoInfo "Local repo created from DVD media"
}

# ---------------------------------------------------
# setupNWRepoNodeZero
# ---------------------------------------------------
setupNWRepoNodeZero() {
    echoInfo "Creating NetWitness Repository on Node-Zero"
    if [ ! -d ${NW_REPO} ]; then
        mkdir -p ${NW_REPO} || exitError "Unable to create ${NW_REPO}"
    else
       # cleanup existing local repo
        rm -rf ${NW_REPO} || exitError "Unable to delete ${NW_REPO}"
        mkdir -p ${NW_REPO} || exitError "Unable to create ${NW_REPO}"
    fi

    # check for provided mountpoint
    if [ ! -z ${NW_REPO_MOUNT_POINT} ]; then
        # verify optional mount point exists
        if [ ! -d ${NW_REPO_MOUNT_POINT} ]; then
          exitError "Provided Mount Point repository missing: '${NW_REPO_MOUNT_POINT}'"
        fi
        cp -r ${NW_REPO_MOUNT_POINT} ${NW_REPO} \
            || exitError "Failed to copy ${NW_REPO_MOUNT_POINT} to ${NW_REPO}"
        PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_URL_PROP_NAME}=file://${NW_REPO}")
    else # search for dvd or usb mount point
        is_mntpnt=$(mountpoint /mnt)

        if [ "${BLKDEV_NUM}" -gt "1" ]; then
            # In case of multiple media devices default to usb device.
            echoInfo "Multiple NetWitness installation media detected. Defaulting to USB."
            BLKDEV_DETECT=$(blkid | grep '"OEMDRV"')
        elif [ "${BLKDEV_NUM}" -lt "1" ]; then
            echoWarn "No media devices detected.  NetWitness Repo will not be created."
        fi

        if [[ "${is_mntpnt}" != *"is not a mountpoint"* ]]; then
            echoError "/mnt is a mountpoint. Please unmount /mnt and re-run the script."
        fi

        if [[ "${BLKDEV_DETECT}" == *"OEMDRV"* ]]; then
            usb_media ${BLKDEV_DETECT}
            PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_URL_PROP_NAME}=file://${NW_REPO}")
        elif [[ "${BLKDEV_DETECT}" == *"CentOS 7 x86_64"* ]]; then
            dvd_media ${BLKDEV_DETECT}
            PROP_LIST=(${PROP_LIST[@]} "-p${NW_REPO_URL_PROP_NAME}=file://${NW_REPO}")
        else
            echoWarn "Attempted to locate dvd or usb mountpoint.  Neither found.  Unknown device"
        fi
    fi
}

# ---------------------------------------------------
# cleanupRepo
# ---------------------------------------------------
cleanupRepo() {
    local repoList=(${@})

    echoInfo "Removing default repositories..."
    for repo in ${repoList[@]}; do
        echoDebug "Removing repo: '${repo}'"
        if [ -f /etc/yum.repos.d/${repo}.repo ]; then
            rm -f /etc/yum.repos.d/${repo}.repo \
                || echoWarn "Could not remove repository: '${repo}'"
        else
            echoDebug "Repo '${repo}' not found, skipping..."
        fi
    done
}

# ---------------------------------------------------
# setupRepo
# ---------------------------------------------------
setupRepo() {
    echoInfo "Configuring bootstrap repository..."
    cp ${SCRIPT_HOME}/configuration/bootstrap.repo /etc/yum.repos.d/ \
        || exitError "Failed to copy repo configuration to: '/etc/yum.repos.d'"

    echoInfo "Registering repository keys..."
    if [ ! -d ${BOOTSTRAP_REPO}/keys ]; then
        echoWarn "Repository keys missing, skipping..."
    else
        for keyFile in $(ls ${BOOTSTRAP_REPO}/keys); do
            local keyPath=${BOOTSTRAP_REPO}/keys/${keyFile}
            if [ ${keyFile##*.} == 'imported' ]; then
                # skip marker files...
                echoDebug "Skipping marker file: '${keyFile}'"
            elif grep "PUBLIC KEY BLOCK" ${keyPath} >/dev/null 2>&1; then
                if [ ! -f ${keyPath}.imported ]; then
                    echoInfo "Importing GPG key: '${keyFile}'"
                    rpm --import ${keyPath} \
                        || exitError "Failed to import GPG key: '${keyFile}'"
                    touch ${keyPath}.imported \
                        || echoWarn "Failed to create marker file for: '${keyFile}'"
                else
                    echoDebug "Skipping GPG key (already imported): '${keyFile}'"
                fi
            else
                echoWarn "Skipping unsupported key file: '${keyFile}'"
            fi
        done
    fi
}

# ---------------------------------------------------
# acceptNodeZeroMinion
# ---------------------------------------------------
acceptNodeZeroMinion() {
    #Accept Node Zero minion only if currently unaccepted
    keyOutput=$(${ORCH_CLI_HOME}/bin/orchestrate.sh -k)
    unacceptedNodeZeroOutput=$(echo "${keyOutput}" | grep "Key: ID=${NODE_ID}, STATUS=Pending")
    acceptedNodeZeroOutput=$(echo "${keyOutput}" | grep "Key: ID=${NODE_ID}, STATUS=Provisioned")
    if [ ! -z "${unacceptedNodeZeroOutput}" ] ; then
        echoInfo "Accepting Node Zero Minion"
        ${ORCH_CLI_HOME}/bin/orchestrate.sh --accept-key ${NODE_ID} \
            || exitError "Salt Master Failed to accept the NodeZero Minion key: ${NODE_ID}"
    elif [ ! -z "${acceptedNodeZeroOutput}" ] ; then 
        echoInfo "Node Zero Minion: ${NODE_ID} already accepted"
    else
        exitError "NodeZero Minion key: ${NODE_ID} is not in a known state."
    fi
}

# ---------------------------------------------------
# disableRepo
# ---------------------------------------------------
disableRepo() {
    echoDebug "Disabling bootstrap repository..."
    sed -i "s/^enabled=1/enabled=0/g" /etc/yum.repos.d/bootstrap.repo \
        || echoWarn "Failed to disable bootstrap repository, skipping..."
}

# ---------------------------------------------------
# installPackage
#   ${1}: package name
# ---------------------------------------------------
installPackage() {
    local packageName=${1}
    local verboseOptions="-q"

    echoInfo "Installing package: '${packageName}'"

    if [ ! -z "${VERBOSE}" ]; then
        verboseOptions="-v"
    fi

    if yum list installed ${packageName} >/dev/null 2>&1; then
        echoDebug "Package '${packageName}' already installed, skipping..."
    else
        echoDebug "Package '${packageName}' not found, installing..."
        yum install -y ${verboseOptions} ${packageName} \
            || exitError "Failed to install package: '${packageName}'"
    fi
}

# ---------------------------------------------------
# installPackages
#   ${@}: package list
# ---------------------------------------------------
installPackages() {
    local packageList=(${@})

    for package in ${packageList[@]}; do
        installPackage ${package}
    done
}

# ---------------------------------------------------
# setupCerts
# ---------------------------------------------------
setupCerts() {
    echoInfo "Generating bootstrap certs..."

    if [ -f /etc/pki/tls/certs/localhost.crt -a -f /etc/pki/tls/certs/localhost.key ]; then
        echoDebug "Certs already generated, skipping..."
    else
        # generate bootstrap self-signed cert (replaced downstream by security-server issued certs)
        salt-call --local tls.create_self_signed_cert \
            || exitError "Failed to generate bootstrap certs!"
    fi
}

# ---------------------------------------------------
# getIpAddress
#   Get the ip address of the eth0 interface
# ---------------------------------------------------
getIpAddress() {
    ip -4 addr show eth0 | grep -oP "(?<=inet )[\d\.]+(?=/)"
}

# ---------------------------------------------------
# getMinionID
# ---------------------------------------------------
getMinionID() {
    if [ -f ${MINION_CONFIG} ]; then
        sed -n 's/^id:[ ]*\(.*\)/\1/p' ${MINION_CONFIG}
    fi
}

# ---------------------------------------------------
# registerMinion
#   ${1}: node-zero address (IP or host)
#   ${2}: minion ID
# ---------------------------------------------------
registerMinion() {
    local masterHost=${1}
    local minionId=${2}

    local configPath=$(dirname ${MINION_CONFIG})

    echoInfo "Configuring SaltStack minion..."

    mkdir -p ${configPath} \
        || exitError "Failed to setup directory: '${configPath}'"

    echo "master: ${masterHost}" > ${MINION_CONFIG} \
        || exitError "Failed to write to: '${MINION_CONFIG}'"

    echo "hash_type: sha256" >> ${MINION_CONFIG} \
        || exitError "Failed to write to: '${MINION_CONFIG}'"

    if [ ! -z "${minionId}" ]; then
        echo "id: ${minionId}" >> ${MINION_CONFIG} \
            || exitError "Failed to write to: '${MINION_CONFIG}'"
    fi
}

# ---------------------------------------------------
# getServiceUUID
#   Use our salt call to get the UUID of the service.
#   ${1}: serviceName
# ---------------------------------------------------
getServiceUUID() {
    local serviceName=${1}
    salt "${NODE_ID}" nodeinfo.service_id "${serviceName}" --output txt | grep -oP "(?<='${serviceName}': ')[\w\-]+(?=')"
}

# ---------------------------------------------------
# registerNodeZeroService
#   Register a service with orchestration using the node zero ip address as the host
#   ${1}: service name
#   ${2}: service port
# ---------------------------------------------------
registerNodeZeroService() {
    local serviceName=${1}
    local servicePort=${2}
    local serviceUUID=`getServiceUUID "${serviceName}"`
    local nodeZeroIp=`getIpAddress`

    echoInfo "Registering service - ${serviceName}"
    ${ORCH_CLI_HOME}/bin/orchestrate.sh --register-service \
    --host "${nodeZeroIp}" --port "${servicePort}" --id "${serviceUUID}" --name "${serviceName}" --use-tls > /dev/null

    if [ $? -eq 0 ]; then
        echoInfo "Service successfully registered - ${serviceName}"
    else
        exitError "Failed to register ${serviceName} with orchestration server."
    fi
}

# ---------------------------------------------------
# createNodeJson
#   ${1}: node type (node-zero|node-x)
#   ${2}: custom descriptor category (optional)
#   ${3}: environment specific property array (optional)
# ---------------------------------------------------
createNodeJson() {
    local nodeType=${1}
    local customCategory=${2}
    local envProperties=("${!3}")
    local cachedJsonDir="/opt/rsa/platform/nw-chef/nodes/"

    # removing previous node.json if it exists
    if [ -d ${cachedJsonDir} ]; then
        rm -rf ${cachedJsonDir}
    fi
    
    echoInfo "Configuring ${nodeType} node..."

    if [ ! -d ${COOKBOOK_HOME} ]; then
        exitError "Could not locate RSA cookbooks: '${COOKBOOK_HOME}'"
    fi

    echoDebug "Preparing for chef-run for ${nodeType}..."
    if [ ! -z "${customCategory}" ]; then
        local descriptorCategory=${customCategory}
    elif [ ${nodeType} == "node-zero" ]; then
        local descriptorCategory=BootstrapMaster
    else
        local descriptorCategory=BootstrapMinion
    fi

    if [ ! -z "${IS_DEVMODE}" ]; then
        local descriptorFlags="-d"
    fi
    
    echoDebug "Generating node.json from component descriptor category '${descriptorCategory}'..."
    ${DESCRIPTOR_HOME}/bin/descriptor-generator.sh \
        -i ${DESCRIPTOR_HOME}/data/nw-component-descriptor.json \
        -o ${COOKBOOK_HOME}/node.json \
        ${descriptorFlags} \
        "${envProperties[@]}" \
        :${descriptorCategory} \
        || exitError "Failed to generate node.json at: '${COOKBOOK_HOME}'"
}

# ---------------------------------------------------
# runChefClient
# ---------------------------------------------------
runChefClient() {
    local verboseOptions=""

    if [ ! -z "${VERBOSE}" ]; then
        verboseOptions="--log_level debug"
    fi

    echoDebug "Running chef-client with ${COOKBOOK_HOME}/client.rb..."
    chef-client --local-mode ${verboseOptions} --logfile=${LOG_FILE} -c ${COOKBOOK_HOME}/client.rb \
        || exitError "One or more errors detected while configuring system!"
}

# ---------------------------------------------------
# startServices
#   ${@}: service list
# ---------------------------------------------------
startServices() {
    local serviceList=(${@})

    for service in ${serviceList[@]}; do
        systemctl enable ${service} \
            || exitError "Failed to enable service: '${service}'"

        echoInfo "Stopping service: '${service}'"
        systemctl stop ${service} \
            || exitWarn "Failed to stop service: '${service}'"

        echoInfo "Starting service: '${service}'"
        systemctl start ${service} \
            || exitError "Failed to start service: '${service}'"
    done
}

# list of packages that must be installed by bootstrap (all nodes)
BOOTSTRAP_PACKAGES_COMMON=(
    nw-comp-descriptor-package  # NetWitness component descriptor
    rsa-nwplatform-cm           # NetWitness component cookbooks
    salt-minion                 # Salt minion (for salt-call)
    pyOpenSSL                   # Salt minion dependency
    chef                        # Chef client
)

# list of services that must be started/enabled by bootstrap
BOOTSTRAP_SERVICES_COMMON=(
    salt-minion.service
)

# list of default CentOS repos that should be removed by bootstrap
BOOTSTRAP_CENTOS_REPOS=(
    CentOS-Base
    CentOS-CR
    CentOS-Debuginfo
    CentOS-fasttrack
    CentOS-Media
    CentOS-Sources
    CentOS-Vault
)

# consume arguments
OPTS=$(getopt -o hvzxa:i:l:gdc:r:sm:p:k: --long help,verbose,node-zero,node-x,zero-host:,node-id:,log-file:,generate-uuid,dev-mode,category:,repo-url:,disable-ssl-verify,mount-path:,property,superuser-password: -n 'bootstrap.sh' -- "$@")

# check for argument parse errors
if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi

# normalize arguments
eval set -- "${OPTS}"

PROP_LIST=()

# process arguments
while true; do
    case "${1}" in
        -h | --help)
            usage
            ;;
        -v | --verbose)
            VERBOSE=true
            shift
            ;;
        -z | --node-zero)
            IS_MASTER=true
            NODE_TYPE=node-zero
            shift
            ;;
        -x | --node-x)
            IS_MINION=true
            NODE_TYPE=node-x
            shift
            ;;
        -g | --generate-uuid)
            IS_AUTOID=true
            shift
            ;;
        -d | --dev-mode)
            IS_DEVMODE=true
            shift
            ;;
        -a | --zero-host)
            ADMIN_HOST=${2}
            shift 2
            ;;
        -i | --node-id)
            NODE_ID=${2}
            shift 2
            ;;
        -l | --log-file)
            LOG_FILE=${2}
            shift 2
            ;;
        -c | --category)
            CUSTOM_CATEGORY=${2}
            shift 2
            ;;
        -r | --repo-url)
            NW_REPO_URL=${2}
            shift 2
            ;;
        -s | --disable-ssl-verify)
            DISABLE_SSL_VERIFY=true
            shift
            ;;
        -m | --mount-path)
            NW_REPO_MOUNT_POINT=${2}
            shift 2
            ;;
        -p | --property)
            PROP_LIST+=("-p${2}")
            shift 2
            ;;
        -k | --superuser-password)
            SUPERUSER_PASSWORD=${2}
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

# check if minion ID already configured from a previous run
currentMinionId=$(getMinionID)
if [ ! -z "${currentMinionId}" ]; then
    # if custom node ID provided, it must match current minion ID (changing node IDs not supported)
    [ -z "${NODE_ID}" -o "${NODE_ID}" == ${currentMinionId} ] \
        || exitError "Invalid node ID '${NODE_ID}' - system already registered with ID: '${currentMinionId}'"
    
    # always use existing minion ID if previously registered
    NODE_ID=${currentMinionId}
fi

# set defaults: admin host when running on node-zero
[ -z "${ADMIN_HOST}" -a ! -z "${IS_MASTER}" ] && ADMIN_HOST=localhost

# set defaults: log file path (current workdir)
[ -z "${LOG_FILE}" ] && LOG_FILE=./bootstrap.log

# set defaults: auto-generate node id (UUID) if needed
[ -z "${NODE_ID}" -a ! -z "${IS_AUTOID}" ] && NODE_ID=$(uuidgen)

# check arguments
if [ -z "${IS_MASTER}" -a -z "${IS_MINION}" ]; then
    exitUsage "please specify a bootstrap type"
elif [ ! -z "${IS_MASTER}" -a ! -z "${IS_MINION}" ]; then
    exitUsage "cannot specify both node-zero and node-x"
elif [ ! -z "${NW_REPO_MOUNT_POINT}" -a ! -z "${NW_REPO_URL}" ]; then
    exitUsage "cannot specify both an nw repo mount point and an nw repo url"
elif [ -z "${ADMIN_HOST}" ]; then
    exitUsage "please specify node-zero host/IP"
elif [ -z "${NODE_ID}" ]; then
    exitUsage "please specify either a node ID or select auto-generate"
#elif [ -z "${SUPERUSER_PASSWORD}" ]; then
#    exitUsage "please specify the superuser password"
#    temporarily disable the superuser password enforcement until process has been finalized.
fi

# set default superuser password
[ -z "${SUPERUSER_PASSWORD}" ] && SUPERUSER_PASSWORD="netwitness"

# check for prerequisites
checkSystem

echo ""
echo "+---------------------------------------------------+"
echo "|              NetWitness Bootstrap                 |"
echo "+---------------------------------------------------+"
echo ""

# remove default repositories
cleanupRepo ${BOOTSTRAP_CENTOS_REPOS[@]}

# configure the bootstrap repository
setupRepo

# install all common packages needed for the bootstrap chef run
installPackages ${BOOTSTRAP_PACKAGES_COMMON[@]}

# setup bootstrap certs for salt master (node-zero only)
[ ! -z "${IS_MASTER}" ] \
    && setupCerts

# register salt minion (NOTE: runs on both node-zero and node-x)
registerMinion ${ADMIN_HOST} "${NODE_ID}"

addHostEntry ${NODE_TYPE} ${ADMIN_HOST}

# setup NetWitness repo (if not specified and on node-zero only)
if [ ! -z "${IS_MASTER}" ] && [ -z "${NW_REPO_URL}" ]; then
      setupNWRepoNodeZero
fi

# add nw repo properties to property list
addNWRepoProperties ${NW_REPO_MOUNT_POINT}

# add host.id property if node_id available (otherwise use descriptor defaults)
if [ ! -z "${NODE_ID}" ]; then
    PROP_LIST=(${PROP_LIST[@]} "-p${GLOBAL_HOST_ID_PROP_NAME}=${NODE_ID}")
fi

# On node-zero, we run the nw-security-bootstrap cookbook first before starting our normal chef run.
if [ ! -z "${IS_MASTER}" ] ; then

    # send credentials to cookbooks
    SECURITY_BOOTSTRAP_PROP_LIST=("${PROP_LIST[@]}")
    SECURITY_BOOTSTRAP_PROP_LIST=(${SECURITY_BOOTSTRAP_PROP_LIST[@]} "-p${NW_PKI_SS_CLIENT_USERID_PROP_NAME}=local")
    SECURITY_BOOTSTRAP_PROP_LIST=(${SECURITY_BOOTSTRAP_PROP_LIST[@]} "-p${NW_PKI_SS_CLIENT_PASSWORD_PROP_NAME}=${SUPERUSER_PASSWORD}")
    SECURITY_BOOTSTRAP_PROP_LIST=(${SECURITY_BOOTSTRAP_PROP_LIST[@]} "-p${NW_PKI_SS_CLIENT_HTTP_FALLBACK_PROP_NAME}=true")

    # run chef with the minimized run list.
    echoInfo "Running chef with SecurityBootstrap category."
    createNodeJson ${NODE_TYPE} "SecurityBootstrap" SECURITY_BOOTSTRAP_PROP_LIST[@]

    # replace run list with nw-security-bootstrap only.
    sed -r -i 's/("run_list" : \[)(.*)(\])/\1 "recipe[nw-security-bootstrap]" \3/' ${COOKBOOK_HOME}/node.json
    runChefClient
fi

# run chef recipes from the bootstrap cookbook
createNodeJson ${NODE_TYPE} "${CUSTOM_CATEGORY}" PROP_LIST[@]
runChefClient

if [ ! -z "${IS_MASTER}" ] ; then
    #accept NodeZero minion key
    acceptNodeZeroMinion

    # give orchestration server some time to create the host record
    sleep 30

    # register rabbit and mongo with orchestration with these names and ports
    registerNodeZeroService rabbitmq 5672
    registerNodeZeroService mongo 27017
fi
# start and enable services
startServices ${BOOTSTRAP_SERVICES_COMMON[@]}

# disable the bootstrap repository
disableRepo

# success...
echoInfo "Bootstrap completed successfully!"
exit 0
