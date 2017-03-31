# rsa-esa-analytics-server-cookbook

This cookbook configures the rsa-esa-analytics-server Netwitness service.

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

* `['rsa-esa-analytics-server']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['rsa-esa-analytics-server']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['rsa-esa-analytics-server']['packages']` - An array of package names and
  versions to be installed
* `['rsa-esa-analytics-server']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['rsa-esa-analytics-server']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['rsa-esa-analytics-server']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.
* `['rsa-esa-analytics-server']['esa_account']` - Name of esa account in mongo
* `['rsa-esa-analytics-server']['esa_pw']` - Password for esa account pw in mongo
* `['rsa-esa-analytics-server']['esa_query_account']` - Name of esa_query account
  in mongo
* `['rsa-esa-analytics-server']['esa_query_pw']` - Password for esa_query account
  in mongo

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[rsa-esa-analytics-server]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
