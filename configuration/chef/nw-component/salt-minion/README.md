# salt-minion-cookbook

This cookbook configures the salt-minion service.

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
* `install`

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

### install

Syncs the salt minion with the salt master to retrieve any master specific
custom modules.

## Attributes

* `['salt-minion']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['salt-minion']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['salt-minion']['packages']` - An array of package names and
  versions to be installed
* `['salt-minion']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['salt-minion']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['salt-minion']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[salt-minion]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
