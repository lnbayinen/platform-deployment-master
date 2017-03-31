# cloud-configs

This directory contains cloud-init related configuration files.  

Assumes access to internet. If internet access is not available define
custom centos repos in *`host_config.yaml`*

All YAML cloud-init configs and templates must be compiled in a single file using
`write-mime-multipart` (part of the cloud-image-utils package in  Ubuntu). If you don't have this file available, I provide Vagrant template in the parent directory, to automatically compile the file after you made changes.
