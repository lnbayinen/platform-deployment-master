# rsa-audit-server-cookbook

This cookbook configures the rsa-audit-server Netwitness service.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.1+

### Cookbooks

* `nw-base`

## Recipes

Executes the following recipes:
* accounts
* packages
* firewall
* filesystem
* services
* config

### accounts

Creates the service account required to support the service.

### packages

Installs the operating system packages defined for this Netwitness component.

### firewall

Adds any needed firewall rules using the `firewalld` package.

### filesystem

Utilizes the filesystem resource (from nw-base) to apply directory, file,
and symlink configurations specified in the component descriptor.

### services

Ensures the services related to the installed packages are enabled and
started.

### config

Creates a logstash configuration file and restarts the service at the end.

/etc/logstash/conf.d/rsa-audit-server.conf'

## Attributes

* `['rsa-audit-server']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['rsa-audit-server']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['rsa-audit-server']['packages']` - An array of package names and
  versions to be installed
* `['rsa-audit-server']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['rsa-audit-server']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[rsa-audit-server]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
