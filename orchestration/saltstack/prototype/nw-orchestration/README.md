# nw-orchestration

Proof of concept creating SaltStack master with two minions

Usage:
```
openstack stack create --wait -e salt_env.yaml -t salt.yaml <heat stack name>
```

## Assumptions
* Works only on CentOS 7
* Requires access to the internet

## Parameters
**image**. Id of CentOS 7 OpenStack image

**flavor**. OpenStack flavor (default: m1.small)

**private_network**. OpenStack project's private network

**private_subnet**. OpenStack project's private subnet

**external_network**. OpenStack external network

**key_name**. SSH key for accessing the servers

**rpm_server**. URL containing Node0 and NodeX bootstrap RPMs

## TODOs
* The rpm_server should be converted to a yum repo
* Missing cookbook RPMs. This step is manual at tis point
