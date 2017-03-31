# nw-pki-cookbook

This cookbook configures certificates, keystores, and truststores for the various Netwitness services.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.5+

### Cookbooks

* `nw-base`
* `firewall`

## Recipes

### default

Executes the following recipes:
* `accounts`
* `groups`
* `packages`
* `firewall`
* `filesystem`
* `services`
* `ca_stage`
* `certificates`
* `keystores`
* `truststores`
* `trustpeer`

### accounts

Creates the service account required to support the service.

### groups

Creates the user groups required to support the service.

### packages

Installs the operating system packages defined for this Netwitness component.

### firewall

Configures the firewall ports defined for this Netwitness component.

### filesystem

Utilizes the filesystem resource (from nw-base) to apply directory, file,
and symlink configurations specified in the component descriptor.

### services

Enables and starts the services defined for this Netwitness component.

### ca_stage

Retrieves the CA certificate (for downstream use by the certificate and
truststore recipes/resources).

### certificates

Creates certificates (see [component descriptor][1] `certificates` attribute).

### keystores

Creates keystores (see [component descriptor][1] `certificates.exports` attribute).

### truststores 

Creates truststores (see [component descriptor][1] `trusts` attribute).

### trustpeer 

Retrieves the node-zero/admin server certificate for trustpeer configuration.

## Attributes

* `['nw-pki']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-pki']['groups']` - An array of groups containing the
  group name, gid, and members (account usernames)
* `['nw-pki']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-pki']['packages']` - An array of package names and
  versions to be installed
* `['nw-pki']['filesystem']` - Files, directories, and symlinks
  configuration (see [component descriptor][1] for details)
* `['nw-pki']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-pki']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.
* `['nw-pki']['certificates']` - An array of certificate
  configurations and certificate export (keystore) requirements
  (see [component descriptor][1] for details)
* `['nw-pki']['trust']` - Trust configuration with truststore exports
  (see [component descriptor][1] for details)
* `['nw-pki']['trust_peer']` - Trust peer attributes:
  * `cert_pem` - peer certificate path
* `['nw-pki']['ca']` - CA configuration attributes:
  * `devmode` - Development CA mode
    * `'disabled'`: (default) CSRs will be processed by the Security Server
    * `'enabled'`: CSRs will be processed by the development CA
      (for non-production use only)
    * `'mixed'`: CSRs will be processed by the development CA only if the
      Security Server is not available; however, development CA identity
      will be used for truststores and other PKI operations
      (for non-production use only)
  * `cert_pem` - CA certificate path
  * `cert_meta` - CA certificate attribute tracking file
* `['nw-pki']['dn_base']` - base DN for certificate subject DN 
* `['nw-pki']['key_size']` - key length (i.e. 2048)
* `['nw-pki']['ss_client']` - Security client configuration (provided via
  component descriptor dynamic/environment attributes):
  * `userid` - API userID
  * `password` - API password
  * `http_fallback` - set to true to allow client to use HTTP when AMQP
    is not available (NOTE: should only be enabled during the bootstrap
    "pre-chef" run)

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-pki]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```

[1]: https://github.rsa.lab.emc.com/asoc/platform-services/tree/master/admin/nw-comp-descriptor

