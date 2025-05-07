#!/bin/bash

installation_type=$1
template_name=$2
template_version=$3
template_type=$4
admin_shell=$5
sic_key=$6
allow_upload_download=$7
password_hash=$8
os_version=$9
host_name=${10}
enable_metrics=${11}
maintenance_mode_password_hash=${12}

python3 /etc/cloud_config.py "installationType='${installation_type}'" "passwordHash='${password_hash}'" "sicKey='${sic_key}'" "osVersion='${os_version}'" "allowUploadDownload='${allow_upload_download}'" "templateName='${template_name}'" "templateVersion='${template_version}'" "templateType='${template_type}'" "hostName='${host_name}'" "shell='${admin_shell}'" "enableMetrics='${enable_metrics}'" "MaintenanceModePassword='${maintenance_mode_password_hash}'"

touch /etc/finished_user_data
