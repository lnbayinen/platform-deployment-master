# nw-security-bootstrap-cookbook

This cookbook is a special one that bootstraps the RSA Security Server service and
runs other cookbooks that set up the infrastructure of node zero.

When the Security Server first runs, it must be passed the superuser password from 
bootstrap and started with HTTP enabled.

In this mode, nw-pki can successfully retrieve the CA and sign its node cert.

Then, nw-rabbitmq and nw-mongo will run to complete the initial set up of node zero.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.1+

### Cookbooks

* `nw-base`
* `nw-repositories`
* `firewall`
* `nw-pki`
* `nw-rabbitmq`
* `nw-mongo`

## Recipes

### default

Executes the following recipes:
* `nw-repositories::default`
* `accounts`
* `groups`
* `packages`
* `firewall`

These recipes only run if bootstrap is required.
* `bootstrap`
* `nw-pki::default`
* `nw-rabbitmq::default`
* `nw-mongo::default`
* `cleanup`

### accounts

Creates the service account required to support the service.

### groups

Creates the user groups required to support the service.

### packages

Installs the operating system packages defined for this Netwitness component.

### firewall

Configures the firewall ports defined for this Netwitness component.

### bootstrap

Creates a systemd override configuration file that provides java options
to the security server to enable http and set the superuser password

### cleanup

Removes the configuration files created by the bootstrap recipe to allow
the security to start up in its default state.

## Attributes

* `['nw-security-bootstrap']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-security-bootstrap']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-security-bootstrap']['groups']` - An array of groups containing the
  group name, gid, and members (account usernames)
* `['nw-security-bootstrap']['packages']` - An array of package names and
  versions to be installed
* `['nw-security-bootstrap']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-security-bootstrap']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-security-bootstrap]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2017, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
