#!/bin/bash
rpm -ivh http://$RPM_SERVER/repos/misc/nwnodeX-bootstrap-0-1.noarch.rpm
/opt/rsa/nwnodeX-boostrap/bootstrap-nodeX.sh $MASTER_IP
