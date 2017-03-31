# nw-component-tests InSpec Profile
Functional tests for RSA NetWitness services


## Invoking InSpec Tests
The current repository assumes InSpec controls are generated from the mvctrl.py script, and it is used by a Jenkins pipeline. If you like to run these tests manually,
copy the appropriate components from all-tests to controls directory and call the inspec command manually (depends how it has been deployed on your system)

## all-tests
The controls-all directory contains all functional tests for each NetWitness service. This directory is not being used by InSpec. All files here are being copied on demand to the controls directory.

## controls
The list of InSpec control file in this directory is based on the node.json file located on the system we are testing. The whole process of populating this directory with the appropriate control file, is handled by Jenkins. When InSpec is executed it reads all control files in this directory.

## util
Directory containing helper scripts to assist in automation of functional tests.
* **component_list.txt**. A static hardcoded list of components, based on the descriptor file.
* **build_controls.sh**. Shell script that generates InSpec control tests
* **genrated_tests**. A temporary directory that holds InSpec tests.


## What is being tested
All tests assume a valid node.json file, that is being used by Chef to deploy each component. Each control script reads the node.jsqon file and based on the attributes assigned to each component, it will perform the appropriate test. The following categories are currently being tested:

* **Firewall rules**. Tests is firewall rules for a specific component have been applied successfully to the system.
* **Component accounts**. Currently only user account(s) related to a component is being tested.
* **Component RPM packages**. Packages and versions of packages installed on the system related to a component. In developer environments package versions are not tested.
* **Component services**. Running services part of the component.
* **Component service ports**. Tests service network ports. Note this test assumes that ports have been defined in the firewall section. There can be cases where a service has a listening port, however it is not tested because it is not defined in the firewall section of the component's node.json.


## TODO
The build_controls.sh should be replaced with a different (likely python) script that creates specific InSpec files and add controls on demand.
