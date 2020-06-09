#!/bin/bash
echo template_name: autoscale >> /etc/cloud-version
echo template_version: 20200203 >> /etc/cloud-version
pwd_hash='${pwd_hash}'
echo "set admin password"
clish -c "set user admin password-hash $pwd_hash" -s
enable_cloudwatch=false
clish -c "set user admin shell /bin/bash" -s
