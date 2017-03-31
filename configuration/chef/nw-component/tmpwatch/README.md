# tmpwatch-cookbook

This cookbook configures the tmpwatch service. 

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

### config

Manages the /etc/cron.daily/tmpwatch configuration file. 

By default, tmpwatch will remove files in /tmp that have not been accessed in 10 days. This can cause issues with static resources deployed by our java services, such as html/js resources and .class files.

We modify the configuration file to prevent the deletion of these files.

## Attributes

* `['tmpwatch']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['tmpwatch']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['tmpwatch']['packages']` - An array of package names and
  versions to be installed
* `['tmpwatch']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['tmpwatch']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['tmpwatch']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[tmpwatch]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
