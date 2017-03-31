# nw-rabbitmq-cookbook

This cookbook configures the nw-rabbitmq Netwitness service.

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
* `serviceinfo`
* `config`
* `plugins`
* `vhosts`
* `users`

### accounts

Creates the service account(s) required to support the service.

### groups

Creates the user groups required to support the service.

### packages

Installs the operating system packages needed for this software.

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

### config

Deploys `/etc/rabbitmq/rabbitmq.config` with configuration parameters
defined from node attributes, including:

* Listener port assignment for AMQP and HTTP
* TLS enablement and configuration
* Enable guest account access beyond localhost
* Set standard TLS parameters for the in-built AMQP client (federation, shovel)

### plugins

Enables one or more RabbitMQ plugins.

### vhosts

Creates one or more RabbitMQ vhosts.

### users

Creates one or more RabbitMQ users. Users can optionally be made RabbitMQ
administrators, and/or have permissions defined for one or more vhosts.

## Attributes

* `['nw-rabbitmq']['amqp_port']` - Port number for the AMQP listener
* `['nw-rabbitmq']['amqps_port']` - Port number for the AMQPS listener
* `['nw-rabbitmq']['accounts']` - An array of names and uids for
  service accounts required by packages installed by this cookbook
  (can also optionally specify account home and manage_home)
* `['nw-rabbitmq']['ciphers']` - An optional array of SSL/TLS ciphers to
  restrict the ones available to RabbitMQ; see <http://www.rabbitmq.com/ssl.html>
  * Note: The array members should be strings, in the form of
    `{rsa, aes256_cbc, sha256}` or simliar, as they will be used verbatim
    in the configuration file
* `['nw-rabbitmq']['federation']` - An array of federation definitions that
  should be created in RabbitMQ
* `['nw-rabbitmq']['firewall_rules']` - An array of firewall rules
  that should be created to support the packages installed by this cookbook
* `['nw-rabbitmq']['groups']` - An array of groups containing the
  group name, gid, and members (account usernames)
* `['nw-rabbitmq']['mgmt_port']` - Port number for the HTTP management/REST
  API listener
* `['nw-rabbitmq']['packages']` - An array of package names and
  versions to be installed
* `['nw-rabbitmq']['plugins']` - An array of RabbitMQ plugins that
  will be enabled
* `['nw-rabbitmq']['policies']` - An array of RabbitMQ policy definitions that
  will be set
* `['nw-rabbitmq']['filesystem']` - Files, directories, and symlinks
  configuration (See component descriptor documentation for details).
* `['nw-rabbitmq']['service_names']` - An array of services that
  will be enabled and started after package installation
* `['nw-rabbitmq']['environment_opts']` - A hash containing properties 
  that will be passed as environment variables to the services.
* `['nw-rabbitmq']['tls_versions']` - An optional array of SSL/TLS versions
  to restrict the ones available to RabbitMQ; see <http://www.rabbitmq.com/ssl.html>
* `['nw-rabbitmq']['users']` - An array of user definitions that should be
  created in RabbitMQ
* `['nw-rabbitmq']['vhosts']` - An array of vhost paths that should be
  added to RabbitMQ

### RabbitMQ Policy Defintion

One or more of the following structures can be added to the `policies` node
attribute array to set RabbitMQ policies.

    {
      "name": "ttl",
      "pattern": "rabbitmq.log",
      "vhost": "logcollection",
      "params": {
        "message-ttl": 300000
      },
      "apply_to": "queues"
    }

All of the `name`, `pattern`, and `params` values are mandatory. If unspecified,
the `vhost` value default is '/', and the `apply_to` value default is 'all'.

See also [RabbitMQ Documentation](http://www.rabbitmq.com/parameters.html#policies)

### RabbitMQ User Definition

One or more of the following structures can be added to the `users` node
attribute array to create or modify RabbitMQ users and set vhost permissions.

    {
      "name": "my_user_name",
      "password": "optional_password",
      "administrator": true|false,
      "vhosts": [
        {
          "name": "/",
          "permissions": ".* .* .* "
        }
      ]
    }

Only `name` is mandatory. The `password` field can be omitted, to create a
user with no password. Omitting the `administrator` field is identical to
setting the value to `false`. Definitions for vhosts are also optional.

## Lightweight Resource Providers

### federation

Used to create or remove an upstream and policy for federation of an exchange
in RabbitMQ.

#### Actions

* `:create` creates a new upstream and policy
* `:remove` removes an existing upstream and policy

#### Parameters

These parameters are required by the LWRP:

* `name` Symbolic name to be assigned to the upstream definition
* `uri` AMQP URI of the federated (upstream) broker, usually this node
* `pattern` Regular expression pattern to define matching queues/exchanges via
  policy
* `policy_name` Symbolic name to be assigned to the upstream policy; this is
  separate from `name` so that a single policy could be shared across multiple
  upstreams

Optional parameters:

**Note**: Some of these values have an internal default in RabbitMQ, which will
be used if omitted here; see the documentation for further details.

* `all_upstreams` Boolean, whether to select all defined upstreams or not
* `upstream_set` Name of a defined federation upstream set to be used
* `apply_to` One of 'queues', 'exchanges', or 'all'
* `exchange` Name of the exchange on the upstream broker to be federated - if
  omitted, each upstream exchange will map to a same-named downstream exchange
* `prefetch_count` Maximal number of unacked messages copied at once
* `reconnect_delay` Duration in seconds before reconnecting to the broker
* `ack_mode` One of 'on-confirm', 'on-publish', or 'no-ack'
* `trust_user_id` Boolean, whether RabbitMQ should trust the supplied user id
* `queue` Name of the exchange on the upstream broker to be federated - if
  omitted, each upstream exchange will map to a same-named downstream exchange
* `max_hops` Maximal number of federation links to traverse before a message is
  discarded
* `expires` Expiry time in milliseconds after which an upstream queue for a
  federated exchange may be deleted, if the connection is lost
* `message_ttl` Expiry time in milliseconds for messages in the upstream queue

Connection definition parameters (for the REST API call):

* `host` Hostname or IP address of the downstream broker (default: 127.0.0.1)
* `port` Port number of the AMQP listener on the downstream broker (default:
  15672)
* `user` Username for authentication from downstream to upstream (default:
  guest)
* `pass` Password for authentication from downstream to upstream (default:
  guest)
* `vhost` Vhost on the downstream broker (default: /)

#### Examples

    nw_rabbitmq_federation 'rsa-upstream' do
      host '10.11.12.13'
      uri "amqp://#{node['ipaddress']}"
      pattern '^rsa\.'
      apply_to 'exchanges'
    end

### policy

Used to set or clear RabbitMQ policies for queues and exchanges.

#### Actions

* `:set` applies a policy definition
* `:clear` removes a policy definition
* `:list` lists current policies

#### Example

    nw_rabbitmq_policy 'ttl' do
      vhost '/'
      pattern 'my.queue'
      params(
        'message-ttl' => 86400
      )
      apply_to 'queues'
    end

### plugin

Used to enable or disable plugins for RabbitMQ.

#### Actions

* `:enable` enables a plugin
* `:disable` disables a plugin

#### Example

    nw_rabbitmq_plugin 'example' do
      action :enable
    end

### user

Used to create, modify, or delete RabbitMQ users.

#### Actions

* `:add` adds a new user
* `:delete` deletes an existing user
* `:change_password` modifies the password for a user
* `:clear_password` removes the password for a user
* `:set_tags` assigns tags to a user
* `:clear_tags` removes tags from a user
* `:set_permissions` assigns permissions to a user for a vhost
* `:clear_permissions` removes permissions from a user for a vhost

#### Parameters

* `name` Name of the user
* `password` Password to be assigned (or changed)
* `vhost` Name of the vhost to assign or remove permissions
* `permisssions` String describing RabbitMQ permissions to be added or removed

#### Examples

    nw_rabbitmq_user 'myuser' do
      password 'weakpassword'
      action :add
    end

    nw_rabbitmq_user 'myuser' do
      tag 'administrator'
      action :set_tag
    end

### vhost

Used to create or remove vhosts from RabbitMQ.

#### Actions

* `:add` creates a vhost
* `:delete` removes a vhost

#### Example

    nw_rabbitmq_vhost '/foo/bar' do
      action :add
    end

## Usage

Set your run\_list as follows:

```json
{ "run_list": [ "recipe[nw-rabbitmq]" ] }
```

## License and Authors

**Author:** ASOC Platform Engineering

**Copyright:** 2016, RSA Security, LLC

```text
    All Rights Reserved - Do Not Redistribute
```
