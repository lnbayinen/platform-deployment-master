# nw-repositories-cookbook

Configures all of the required yum repositories for Netwitness.

## Requirements

### Platforms

* CentOS 7

### Chef

* Chef 12.1+

### Cookbooks

* [yum][1]

## Recipes

### default

* Invokes the `cleanup` and `add` recipes

### add

* Adds the repositories defined in `['nw-repositories']['repos']`

### addkeys

* Adds the RPM GPG keys defined in `['nw-repositories']['keys']`

### cleanup

* Removes the default CentOS installation repositories

### remove

* Removes the repositories defined in `['nw-repositories']['repos']`

## Attributes

### \['nw-repositories']['cleanup']

An array of the repository IDs that should be flushed from the system during
the `cleanup` recipe. Defaults to the list of repositories configured by
CentOS during installation.

### \['nw-repositories']['keys']

An array of filenames representing RPM GPG keys, as shipped with the cookbook
in `files/default/keys`.

### \['nw-repositories']['repos']

A hash of repository definitions, each with the following keys:

* `name` - Brief title or short descriptive text
* `baseurl` - URL for the repository
* `excludes` - (optional) Array of package names or wildcards that should be
  excluded by yum
* `cost` - (optional) Integer cost metric to assign more or less weight to
  repositories, such that packages with the same name are more or less
  preferred by yum

**NOTE**: `repos` should be defined in the component descriptor.

## Usage

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security

```text
    All Rights Reserved - Do Not Redistribute
```

[1]: <https://supermarket.chef.io/cookbooks/yum> (yum cookbook)
