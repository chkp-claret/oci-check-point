#!/bin/bash

installation_type=$1
template_name=$2
template_version=$3
template_type=$4
admin_shell=$5
allow_upload_download=$6
password_hash=$7
os_version=$8
host_name=$9
management_gui_client_network=${10}
maintenance_mode_password_hash=${11}

python3 /etc/cloud_config.py "installationType='${installation_type}'" "templateName='${template_name}'" "templateVersion='${template_version}'" "templateType='${template_type}'" "shell='${admin_shell}'" "allowUploadDownload='${allow_upload_download}'" "passwordHash='${password_hash}'" "osVersion='${os_version}'" "hostName='${host_name}'" "managementGUIClientNetwork='${management_gui_client_network}'" "MaintenanceModePassword='${maintenance_mode_password_hash}'"

touch /etc/finished_user_data
