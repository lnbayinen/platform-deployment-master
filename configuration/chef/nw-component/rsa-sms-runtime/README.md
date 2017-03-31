# rsa-sms-runtime-cookbook

This cookbook configures the Netwitness rsa-sms-runtime service.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.1+

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

## Attributes

* `['rsa-sms-runtime']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['rsa-sms-runtime']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['rsa-sms-runtime']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['rsa-sms-runtime']['groups']` - An array of groups containing the
  group name, gid, and members (account usernames)
* `['rsa-sms-runtime']['packages']` - An array of package names and
  versions to be installed
* `['rsa-sms-runtime']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['rsa-sms-runtime']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[rsa-sms-runtime]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2017, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
