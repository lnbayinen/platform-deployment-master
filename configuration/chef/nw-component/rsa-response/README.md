# rsa-response-cookbook

This cookbook configures the rsa-response Netwitness service.

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
* `packages`
* `firewall`
* `filesystem`
* `services`
* `serviceinfo`
* `config`

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

### serviceinfo

Retrieves the Launch created service-id and saves it to a location on disk.

### config
Adds user and database config to mongo.

## Attributes

* `['rsa-response']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['rsa-response']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['rsa-response']['packages']` - An array of package names and
  versions to be installed
* `['rsa-response']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['rsa-response']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['rsa-response']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.
* `['rsa-response']['im_account']` - Name of the im account in mongo
* `['rsa-response']['im_pw']` - Password for im account in mongo

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[rsa-response]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
