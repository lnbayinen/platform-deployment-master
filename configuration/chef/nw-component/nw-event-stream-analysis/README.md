# nw-event-stream-analysis-cookbook

This cookbook configures the Netwitness ESA service.

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
* `collectd`

### accounts

Creates the service account(s) required to support the service.

### packages

Installs the operating system packages defined for this software.

### firewall

Adds any needed firewall rules using the `firewalld` package.

### filesystem

Utilizes the filesystem resource (from nw-base) to apply directory, file,
and symlink configurations specified in the component descriptor.

### services

Ensures the services related to the installed packages are enabled and
started.

### serviceinfo

Generates a service UUID for tracking and saves it to a location on disk.

### collectd

Deploys `/etc/collectd.d/esa.conf` with TLS certificate and key paths taken
from the `nw-pki` cookbook. Also deploys a supporting python script installed
by the `rsa-sms-runtime-rt` package.

## Attributes

* `['nw-event-stream-analysis']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-event-stream-analysis']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-event-stream-analysis']['packages']` - An array of package names and
  versions to be installed
* `['nw-event-stream-analysis']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['nw-event-stream-analysis']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-event-stream-analysis']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-event-stream-analysis]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
