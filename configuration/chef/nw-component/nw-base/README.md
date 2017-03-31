# nw-base-cookbook

This cookbook configures common elements of Netwitness systems.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.1+

### Cookbooks

* `nw-repositories`
* `firewall`

## Recipes

### default

Executes the following recipes:
* `collectd`
* `packages`
* `firewall`
* `filesystem`
* `oneoffs`

### collectd

Creates a directory needed by collectd and deploys the service configuration
file template.

### packages

Installs the operating system packages defined for this software.

### firewall

Adds any needed firewall rules using the `firewalld` package.

### filesystem

Utilizes the filesystem resource (from nw-base) to apply directory, file,
and symlink configurations specified in the component descriptor.

### oneoffs

Performs temporary tasks needed during development. All such tasks should
be removed as fixes are applied or the need is otherwise obviated.

## Attributes

* `['nw-base']['firewall_rules']` - An array of firewall rules that should
  be created to support the packages installed by this cookbook
* `['nw-base']['packages']` - An array of package names and
  versions to be installed
* `['nw-jetty']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).

## Usage

This cookbook is intended to be used a dependency of other Netwitness
cookbooks, and should not be directly listed in a run list.

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security

```text
    All Rights Reserved - Do Not Redistribute
```
