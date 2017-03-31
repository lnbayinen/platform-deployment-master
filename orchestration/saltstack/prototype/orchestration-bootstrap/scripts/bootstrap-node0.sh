#!/bin/bash
# Script that installs platform infrastructure components for NetWitness node-0
# Notes and TODO
# 1) Missing checking for existing deployment (will be priority post POC)
# 2) Allow script argument passing
# 3) Better error handling
# 4) Debug feature, and better message control on stdout
# 5) Clean up node-0 functionality
# 6) Redo functionality from where the script might have stopped (broke)
# 7) Do shiny things with getopts

##### SETTINGS #####
CHEF_RPM_PACKAGE="chef-12.12.15-1.el7.x86_64.rpm"
FIRST_NODE0="true"
####################

# Only root or a user with sudo privilege can execute this script
if [ "$EUID" -ne 0 ]
  then echo "Node0 bootstrap requires root privileges. Aborting script execution."
  exit 1
fi

# Check if system is CentOS 7
if [[ -f /etc/os-release ]]; then
    OS_NAME=`gawk -F= '/^NAME/{print $2}' /etc/os-release | sed -e 's/^"//'  -e 's/"$//'`
    OS_VERSION_ID=`gawk -F= '/^VERSION_ID/{print $2}' /etc/os-release | sed -e 's/^"//'  -e 's/"$//'`
else
    echo "Unable to determine operating system version. Missing /etc/os-release."
    exit 1
fi

if [[ "${OS_NAME}" != "CentOS Linux" ]] || [[ "${OS_VERSION_ID}" != "7" ]]; then
    echo "Platform ${OS_NAME} version ${OS_VERSION_ID} not supported."
    exit 1
fi

function chef_client_deploy {
    echo "Delpoying Chef"
    rpm --quiet -ivh https://packages.chef.io/stable/el/7/${CHEF_RPM_PACKAGE}
}


function saltstack_repo {
    echo "Setting up SaltStack yum repository"
    # The 1> /dev/null is to disable printing out the repo in stdout
    tee /etc/yum.repos.d/saltstack.repo 1> /dev/null <<'EOF'
[saltstack-repo]
name=SaltStack repo for Red Hat Enterprise Linux $releasever
baseurl=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
       https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/base/RPM-GPG-KEY-CentOS-7
EOF
}

# This is subject to change. Currently used for the purpose of demo and POC.
function epel_install {
    echo "Installing CentOS 7 EPEL yum repository"
    rpm --quiet -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
}

function install_saltstack_master {
    echo "Installing SaltStack Master"
    yum -y -q install salt-master
    yum -y -q install pyOpenSSL
}

function install_saltstack_api {
    echo "Installing SaltStack API"
    yum -y -q install salt-api
}

function install_saltstack_minion {
    echo "Installing SaltStack Minion"
    yum -y -q install salt-minion
}

function configure_saltstack_master {
    echo "Configuring SaltStack Master and API"
    salt-call --local tls.create_self_signed_cert
tee /etc/salt/master 1> /dev/null <<'EOF'
# Where the master should listen (POC Only)
interface: 0.0.0.0

# Security Settings (POC Only)
auto_accept: True
token_expire: 43200
hash_type: sha256
external_auth:
   pam:
      nwsaltuser:
         - .*

# Salt API Endpoint
rest_cherrypy:
   port: 8000
   ssl_crt: /etc/pki/tls/certs/localhost.crt
   ssl_key: /etc/pki/tls/certs/localhost.key
EOF

}

function configure_saltstack_minion {
    echo "Configuring SaltStack Minion"
    tee /etc/salt/minion 1> /dev/null <<'EOF'
# Master server
master: localhost
hash_type: sha256
EOF

}

function create_saltstack_api_user {
    echo "Creating nwsaltuser"
    useradd -s /usr/sbin/nologin -r -M nwsaltuser -p '$6$rounds=4096$6vn7Y6BSGZ4nqgi$LwsSjEcRRE53w8GFrOxHEOQ2cqw6OdQjVMlFCge9fM6Lb/XNiMUGFn9Cb8P8o10aWHUgLqqgCBjaPvgLPyuL50'
}

function start_services {
    systemctl enable salt-master.service
    systemctl enable salt-api.service
    systemctl enable salt-minion.service
    systemctl start salt-master.service
    systemctl start salt-api.service
    systemctl start salt-minion.service
}


# Main Section
saltstack_repo
epel_install
install_saltstack_master
install_saltstack_api
install_saltstack_minion
create_saltstack_api_user
configure_saltstack_master
configure_saltstack_minion
chef_client_deploy
start_services
