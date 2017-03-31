# nw-log-collector-cookbook

This cookbook configures the Netwitness Log Collector service.

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
* `selinux`
* `rabbitmq`
* `firewall`
* `filesystem`
* `services`
* `serviceinfo`
* `collectd`

### accounts

Creates the service account(s) required to support the service.

### packages

Installs the operating system packages defined for this software.

### rabbitmq

Creates RabbitMQ users and vhosts using the data in
`['nw-log-collector']['rabbitmq']`, in the same manner as it is performed in
`nw-rabbitmq::users` and `nw-rabbitmq::vhosts`.
Installs the `nw_admin` plugin for RabbitMQ, which ships with Log Collector.

### selinux

Creates SELinux policies for collectd, rabbitmq, and syslog.

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

Deploys `/etc/collectd.d/logcollector.conf` with TLS certificate and key paths
taken from the `nw-pki` cookbook, and deploys
`/etc/collectd.d/logcollector-queues.conf` as a static (non-templated) file.
Also deploys two supporting python scripts installed by the
`rsa-sms-runtime-rt` package.

## Attributes

* `['nw-log-collector']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-log-collector']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-log-collector']['packages']` - An array of package names and
  versions to be installed
* `['nw-log-collector']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['nw-log-collector']['rabbitmq']['users']` - An array of RabbitMQ user
  definitions
* `['nw-log-collector']['rabbitmq']['vhosts']` - An array of RabbitMQ vhosts
* `['nw-log-collector']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-log-collector']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-log-collector]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
