# Check Point R81.20 Security Cluster with Gaia 3.10 - BYOL

This quick start deploys two Check Point R81.20 Security Gateways to be configured as a HA cluster.

There are two options for deployment:
- Create a new network with a public and private subnet to launch the gateways into
- Launch the gateways into an existing network

The gateways are configured with the following topology:

![](../images/cp_cluster_topology.png)

Each gateway is created with two VNICs, one on the public subnet and one on the private subnet. 

Each subnet has a virtual secondary private IP created, both of which are assigned to the same gateway instance. The public virtual IP must be a permanent IP to be transfered between VNICs, the option to add an existing permanent IP later is provided. 

If the option for a new network is selected, a public and private subnet are created. A routing table for the private subnet will be created with the backend cluster IP as the default route for all traffic. A routing table for the frontend will have the default route pointed to an internet gateway created.

The First Time Wizard for both instances are handled by a cloud-init script.

The password for the gateway must be set by providing a password hash for the user admin, and password authentication over SSH is disabled by default

Once the deployment has finished, follow this [guide](https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_Network_for_Oracle_Cloud_Getting_Started/Content/Topics-Oracle-GS/Configuring-OCI-Cluster.htm?tocpath=Configuring%20OCI%20Cluster%20in%20Check%20Point%20Security%20Management%7C_____0#Configuring_OCI_Cluster_in_Check_Point_Security_Management) to finish configuring the cluster with a Check Point Security Management Server.

## How to use Terraform CLI

1. Make sure you have terraform v0.12+ cli installed and accessible from your terminal.

```bash
terraform -v
```

![](../images/tf-version.png)

2. You can use the boilerplate available on [terraform.tfvars.template](terraform.tfvars.template) to set up the OCI provider variables or overwrite the variables values defined on [variables.tf](./variables.tf). Rename the file to `terraform.tfvars` so that Terraform CLI can automatically pick it up as the default variables configuration.

You can also define all default values directly on [variables.tf](./variables.tf). However, variables that you want users to specify the value during runtime or you don't want the value persisted on a version control system (as it may contains sensitive data), you can make use of environment variables or typically, terraform.tfvars file.

Note: See the [Inputs](#inputs) section for all the variables description.

3. Initialize your template.

This gives the following output:

```bash
terraform init
```

![terraform init](../images/tf-init.png)

4. Now you should run a plan to make sure everything looks good:

```bash
terraform plan
```

That gives:
![terraform plan](../images/tf-plan1.png)

5. Finally, if everything is good, you can go ahead and run `apply`:

```
terraform apply # will prompt to continue
```

The output of `terraform apply` should look like:
![terraform plan](../images/tf-apply1.png)


6. You now can connect via SSH or HTTPS through the public IP address of the Instance.

7. If you want to destroy the resources previously created. Run `terraform destroy`.
![terraform plan](../images/tf-destroy.png)

8. Finally, you can modify and extend the existing code based on your needs.

## How to use build-orm

[build-orm](./build-orm) is just a wrapper for packaging terraform CLI into the format supported by OCI Resource Manager. In a nutshell, this template will zip this project and remove some files that are not required by ORM, making it easier to deploy.

1. In order to launch it, make sure you have terraform v0.12+ cli installed and accessible from your terminal.

2. Ensure all variables were specified based on *steps 2 and 3* of the above section - "How to use Terraform CLI".

3. Update [Marketplace schema](./marketplace.yaml) template file that exposes the variables to end users on ORM. More information related to Marketplace schema is available [here](https://github.com/oracle-quickstart/oci-quickstart/blob/master/Marketplace%20Stack%20Schema.md)

4. Initialize your template in [build-orm](./build-orm).

```bash
terraform init
```

This gives the following output:

![terraform init](../images/tf-init-orm.png)

5. Now, you can go ahead and run `terraform apply`. That will generate check-point-ha.zip in the `resource-manager` folder :
![terraform plan](../images/tf-apply-orm.png)

You can run `unzip -l resource-manager/check-point-ha.zip` and confirm the content of the zip file:

![terraform plan](../images/unzip-l.png)

6. Alternatively, you can specify a different path to store the zip file by specifying a variable argument `save_to` during apply: `terraform apply -var="save_to"="path/to/zip"`
 
7. Finally, Create a Stack on OCI Resource Manager, configure all the variables and launch it.
![terraform plan](../images/oci-rm.png)

## Inputs
| Name                           | Description                                                                      | Type   | Allowed Values           | Default | Required |
| ------------------------------ | -------------------------------------------------------------------------------- | ------ | ------------------------ | ------- | -------- |
| user_ocid                      | OCID of the user calling the API                                                 | string | "ocid1.user.oc1..."      | N/A     | yes      |
| fingerprint                    | Fingerprint for the public key that was added to this user                       | string |                          | N/A     | yes      |
| private_key_path               | The path to your downloaded private API key file                                 | string |                          | N/A     | yes      |
| tenancy_ocid                   | OCID of your tenancy                                                             | string | "ocid1.tenancy.oc1..."   | N/A     | yes      |
| region                         | An Oracle Cloud Infrastructure region                                            | string | See [Regions](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm#top) | N/A | yes |
| compute_compartment_ocid       | Compartment where Compute and Marketplace subscription resources will be created | string | "ocid1.compartment.oc1..." | N/A     | yes      |
| vm_display_name                | Instance name                                                                    | string |                          | "cloudguard-ha" | no |
| vm_compute_shape               | The shape of the instance                                                        | string | "VM.Standard2.2" <br/> "VM.Standard2.4" <br/> "VM.Standard2.8" <br/> "VM.Standard2.16" <br/> "VM.Standard2.24" <br/> "VM.Standard.E3.Flex" <br/> "VM.Standard.E4.Flex" <br/> "VM.Optimized3.Flex" <br/> "VM.Standard3.Flex" <br/> "VM.Standard.E5.Flex" <br/> | "VM.Standard2.2" | yes |
| vm_flex_shape_ocpus            | Only for Flex Shapes. The total number of OCPUs available to the instance.       | number |                          | 1       | no       |
| availability_domain_name       | The name of the availability domain                                              | string | Ex: "Uocm:PHX-AD-1"      | N/A     | no       |
| availability_domain_number     | (Required if availability_domain_name is not provided) <br/> OCI Availability Domains: 1,2,3 (subject to region availability) | string | "1" <br/> "2" <br/> "3" <br/> | "1" | yes |
| ssh_public_key                 | Public SSH Key to access VM via SSH. It should start with ssh-rsa.               | string | "ssh-rsa ..."            | N/A     | yes      |
| instance_launch_options_network_type | NIC Attachment Type                                                        | string | "VFIO" or "PARAVIRTUALIZED" | "VFIO" | yes      |
| network_compartment_ocid       | Compartment where Network resources will be created                              | string | "ocid1.compartment.oc1..." | N/A     | yes      |
| network_strategy               | Either create new VCN and Subnet or use existing                                 | string | "Create New VCN and Subnet" or "Use Existing VCN and Subnet" | "Create New VCN and Subnet" | yes |
| vcn_id                         | (Existing VCN) OCID of VCN                                                       | string | "ocid1.vcn.oc1..."       | N/A     | no       | 
| vcn_display_name               | (Create new VCN) Name of VCN                                                     | string |              | "cloudguard-ha-vcn" | no |
| vcn_cidr_block                 | (Create new VCN) VCN CIDR                                                        | string |                          | "10.0.0.0/16" | yes |
| vcn_dns_label                  | VCN DNS Label                                                                    | string | Only letters and numbers, starting with a letter. 15 characters max | "ha" | no |
| public_subnet_id               | (Existing subnet) OCID of public subnet                                          | string | "ocid1.subnet.oc1..."    | N/A     | no       |
| public_subnet_display_name     | (Create new subnet) Name of public subnet                                        | string |                          | "frontend-subnet" | no |
| public_subnet_cidr_block       | (Create new subnet) Public subnet CIDR                                           | string |                          | "10.0.0.0/24" | yes |
| public_subnet_dns_label        | (Create new subnet) Subnet DNS Label                                             | string | Only letters and numbers, starting with a letter. 15 characters max | "management" | no |
| private_subnet_id              | (Existing subnet) OCID of existing private subnet                                | string | "ocid1.subnet.oc1..."    | N/A     | no       |
| private_subnet_display_name    | (Create new subnet) Name of private subnet                                       | string |                          | "backend-subnet" | no |
| private_subnet_cidr_block      | (Create new subnet) Private subnet CIDR                                          | string |                          | "10.0.1.0/24" | yes |
| use_existing_ip                | Create a permanent cluster IP or add one later                                   | string | "Create new IP" or "Add IP later" | yes |
| nsg_whitelist_ip               | Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32 | string | | "0.0.0.0/0" | yes |
| nsg_display_name               | The name of the Network Security Group                                           | string |               | "cluster-security-group" | no |
| allow_upload_download          | Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point | string | "true" or "false" |  "true" | yes |
| shell                          | Change the admin shell to enable advanced command line configuration             | string | "/etc/cli.sh" <br/> "/bin/bash" <br/> "/bin/csh" <br/> "/bin/tcsh" <br/> | "/etc/cli.sh" | yes |
| sic_key                        | The Secure Internal Communication key creates trusted connections between Check Point components. Trust is required to install policies on gateways and to send logs between gateways and management servers. | string | Only alphanumeric characters are allowed, and the value must be 12-30 characters long | N/A | yes |
| admin_password_hash            | GW password hashed using MD5 based BSD password algorithm. Can be generated using 'openssl passwd -1 <my_password>' | string | | N/A | yes |
| maintenance_mode_password_hash | Maintenance mode password hash. Can be generated by running 'grub2-mkpasswd-pbkdf2' | string | "grub..."             | N/A     | yes |
| hostname                       | Name for the shell on the machines                                               | string |                          |         | no       |
| enable_metrics                 | Enable CloudGuard metrics in order to send statuses and statistics collected from instances to the OCI Monitor service | string | "true" or "false" | "true" | yes |
