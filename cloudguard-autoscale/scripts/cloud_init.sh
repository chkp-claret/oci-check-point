#!/bin/bash

template_name=$1
template_version=$2
template_type=$3
admin_shell=$4
sic_key=$5
allow_upload_download=$6
password_hash=$7
os_version=$8
host_name=$9
enable_metrics=${10}
maintenance_mode_password_hash=${11}

python3 /etc/cloud_config.py "installationType='AutoScale'" "passwordHash='${password_hash}'" "sicKey='${sic_key}'" "osVersion='${os_version}'" "allowUploadDownload='${allow_upload_download}'" "templateName='${template_name}'" "templateVersion='${template_version}'" "templateType='${template_type}'" "hostName='${host_name}'" "shell='${admin_shell}'" "enableMetrics='${enable_metrics}'" "MaintenanceModePassword='${maintenance_mode_password_hash}'"

touch /etc/finished_user_data

