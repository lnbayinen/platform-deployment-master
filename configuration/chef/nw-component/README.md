# Netwitness Component Cookbooks

These cookbooks will serve as the basis for configuring an operating system to
serve as a particular Netwitness component, such as a broker. Eventually, this
list will expand to incorporate cookbooks for ancillary service dependencies,
including but not limited to Nginx, MongoDB, and/or RabbitMQ.

The `nw-base` cookbook is a dependency of the other cookbooks, and will handle
managing tasks common to the others, such as operating system configuration,
common packages (e.g. Java), etc.

## Cookbooks

### Core

* [nw-archiver][]
* [nw-broker][]
* [nw-concentrator][]
* [nw-decoder][]
* [nw-event-stream-analysis][]
* [nw-log-decoder][]
* [nw-malware-analysis][]

### Infrastructure

* [nw-base][]
* [nw-repositories][]
* [nw-pki][]

### Launch Services

* [admin-service][]
* [config-service][]
* [contexthub-service][]
* [esa-analytics-service][]
* [investigate-service][]
* [orchestration-service][]
* [response-service][]
* [security-service][]

### Legacy Services (Classic UI)

* [nw-jetty][]

### Bootstrap 

* [salt-api][]
* [salt-master][]
* [salt-minion][]

## See Also

Check [VENDOR.md][] for guidance on the process to incorporate third party
cookbooks.

[nw-archiver]: ./nw-archiver/README.md (nw-archiver)
[nw-base]: ./nw-base/README.md (nw-base)
[nw-broker]: ./nw-broker/README.md (nw-broker)
[nw-concentrator]: ./nw-concentrator/README.md (nw-concentrator)
[nw-decoder]: ./nw-decoder/README.md (nw-decoder)
[nw-event-stream-analysis]: ./nw-event-stream-analysis/README.md (nw-nw-event-stream-analysis)
[nw-jetty]: ./nw-jetty/README.md (nw-jetty)
[nw-log-decoder]: ./nw-log-decoder/README.md (nw-log-decoder)
[nw-malware-analysis]: ./nw-malware-analysis/README.md (nw-malware-analysis)
[nw-pki]: ./nw-pki/README.md (nw-pki)
[nw-repositories]: ./nw-repositories/README.md (nw-repositories)
[nw-server]: ./nw-server/README.md (nw-server)
[vendor.md]: ./VENDOR.md (VENDOR.md)
[admin-service]: ./admin-service/README.md (admin-service)
[config-service]: ./config-service/README.md (config-service)
[contexthub-service]: ./contexthub-service/README.md (contexthub-service)
[esa-analytics-service]: ./esa-analytics-service/README.md (esa-analytics-service)
[investigate-service]: ./investigate-service/README.md (investigate-service)
[orchestration-service]: ./orchestration-service/README.md (orchestration-service)
[response-service]: ./response-service/README.md (response-service)
[security-service]: ./security-service/README.md (security-service)
[salt-api]: ./salt-api/README.md (salt-api)
[salt-master]: ./salt-master/README.md (salt-master)
[salt-minion]: ./salt-minion/README.md (salt-minion)
