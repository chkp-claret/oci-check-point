# Check Point R81.20 Security Gateway with Gaia 3.10 - BYOL

This folder contains all assets for deploying Check Point R81.20 Security Gateway with Gaia 3.10 - BYOL from Oracle Cloud Infrastructure Marketplace.

## How to use Terraform CLI

1. Make sure you have terraform v0.12+ cli installed and accessible from your terminal.

```bash
terraform -v
```

![](./images/tf-version.png)

2. Update default variable values on [variables.tf](./variables.tf). At least *Compute Configuration* sections should be updated.

Here is the snippet of the `variables.tf` file.

```hcl
############################
#  Marketplace Image      #
############################

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1.."
  description = "Marketplace - Listing OCID"
}

variable "mp_listing_resource_id" {
  default = "ocid1.image.oc1.."
  description = "Marketplace - Image OCID"
}

variable "mp_listing_resource_version" {
  default = "1.0"
  description = "Marketplace - Package Version Reference"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "simple"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}
```

3. You can define all default values directly on [variables.tf](./variables.tf). However, variables that you want users to specify the value during runtime or you don't want the value persisted on a version control system (as it may contains sensitive data), you can make use of environment variables or typically, terraform.tfvars file.
You can use the boilerplate available on [terraform.tfvars.template](terraform.tfvars.template) to setup the OCI provider variables or overwrite the variables values defined on [variables.tf](./variables.tf). Rename the file to `terraform.tfvars` so that Terraform CLI can automatically pick it up as the default variables configuration.

4. Initialize your template.

This gives the following output:

```bash
terraform init
```

![terraform init](./images/tf-init.png)

5. Now you should run a plan to make sure everything looks good:

```bash
terraform plan
```

That gives:
![terraform plan](./images/tf-plan1.png)

6. Finally, if everything is good, you can go ahead and run `apply`:

```
terraform apply # will prompt to continue
```

The output of `terraform apply` should look like:
![terraform plan](./images/tf-apply1.png)


7. You now can connect via SSH or HTTPS through the public IP address of the Instance.

8. If you want to destroy the resources previously created. Run `terraform destroy`.
![terraform plan](./images/tf-destroy.png)

9. Finally, you can modify and extend the existing code based on your needs.

## How to use build-orm

[build-orm](./build-orm) is just a wrapper for packaging terraform CLI into the format supported by OCI Resource Manager. In a nutshell, this template will zip this project and remove some files that are not required by ORM, making it easier to deploy.

1. In order to launch it, make sure you have terraform v0.12+ cli installed and accessible from your terminal.

2. Ensure all variables were specified based on *steps 2 and 3* of the above section - "How to use Terraform CLI".

3. Update [Marketplace schema](./marketplace.yaml) template file that exposes the variables to end users on ORM. More information related to Marketplace schema is available [here](https://github.com/oracle-quickstart/oci-quickstart/blob/master/Marketplace%20Stack%20Schema.md)

3. Initialize your template.

```bash
terraform init
```

This gives the following output:

![terraform init](./images/tf-init-orm.png)

5. Now, you can go ahead and run `terraform apply`. That will generate orm.zip in `build-orm/dist` folder :
![terraform plan](./images/tf-apply-orm.png)

You can run `unzip -l dist/orm.zip` and confirm the content of the zip file:

![terraform plan](./images/unzip-l.png)

6. Alternatively, you can specify a different path to store the zip file by specifying a variable argument `save_to` during apply: `terraform apply -var="save_to"="path/to/zip"`
 
7. Finally, Create a Stack on OCI Resource Manager, configure all the variables and launch it.
![terraform plan](./images/oci-rm.png)

## GitHub Action Workflow - Automated Packaging

This project uses [GitHub Action Workflow](https://github.com/features/actions) that automatically generates a OCI Resource Manager Stack everytime there is a code change. A new ORM Stack file is hosted under GitHub Releases as a draft. Publishers can modify each Release individually or change the parameters at [ORM Stack](.github/workflows/build-orm-stack.yml) workflow Create Release step to make it public to everyone.

```yaml
 - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          body: |
            Changes in this Release
            - New ORM Stack template ${{ github.ref }}
          draft: true
          prerelease: true
```
