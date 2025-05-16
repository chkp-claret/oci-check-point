# oci-check-point
This is a Terraform module that deploys Check Point solutions on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).  It is developed jointly by Oracle and Check Point.

The [Oracle Cloud Infrastructure (OCI) Quick Start](https://github.com/oracle?q=quickstart) is a collection of examples that allow OCI users to get a quick start deploying advanced infrastructure on OCI.
The oci-check-point repository contains the initial templates that can be used for accelerating deployment of Check Point solutions from local Terraform CLI and OCI Resource Manager.

This repo is under active development.  Building open source software is a community effort.  We're excited to engage with the community building this.

## How this project is organized

This project contains multiple solutions. 

- [cloudguard-autoscale](cloudguard-autoscale): Deploy a Check Point Autoscale solution
- [cloudguard-ha](cloudguard-ha): Deploy a Check Point High Availability Cluster
- [cloudguard-management](cloudguard-management): Deploy a Check Point Management
- [cloudguard-ngfw](cloudguard-ngfw): Deploy a Check Point Gateway

Each solution folder has the following module:
- build-orm: Packages the solution template in OCI [Resource Manager Stack](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Tasks/managingstacksandjobs.htm) format.

## Prerequisites

First off we'll need to do some predeploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).


## How to use these templates

You can easily use these templates pointing to the Images published in the Oracle Cloud Infrastructure Marketplace.
To get it started, navigate to the solution folder and check individual README.md file. 
