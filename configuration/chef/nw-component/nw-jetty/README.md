# nw-jetty-cookbook

This cookbook configures the Netwitness Jetty/SAServer service.

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
* `install`
* `filesystem`
* `services`
* `serviceinfo`

### accounts

Creates the service account(s) required to support the service.

### packages

Installs the operating system packages defined for this software.

### firewall

Adds any needed firewall rules using the `firewalld` package.

### install

Applies configuration customizations for Jetty.

### filesystem

Utilizes the filesystem resource (from nw-base) to apply directory, file,
and symlink configurations specified in the component descriptor.

### services

Ensures the services related to the installed packages are enabled and
started.

### serviceinfo

Generates a service UUID for tracking and saves it to a location on disk.

### collectd

Deploys `/etc/collectd.d/jmx-SAServer.conf` with the node UUID as known to Chef.

## Attributes

* `['nw-jetty']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-jetty']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-jetty']['packages']` - An array of package names and
  versions to be installed
* `['nw-jetty']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['nw-jetty']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-jetty']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.
* `['nw-jetty']['secure_port']` - HTTPS listen port for Jetty
  (defined by the component descriptor)
* `['nw-jetty']['file-owner']` - default owner for files
* `['nw-jetty']['file-group']` - default group for files
* `['nw-jetty']['file-mode']` - default mode for files
* `['nw-jetty']['dir-mode']` - default mode for directories

The following attributes define the SSL context for jetty in the jetty-ssl.xml file.

* `['nw-jetty']['keystore_path']` - path to keystore 
* `['nw-jetty']['keystore_type']` - type of store, ie pkcs12
* `['nw-jetty']['truststore_path']` - path to truststore
* `['nw-jetty']['truststore_type']` - type of store, ie pkcs12

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-jetty]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
