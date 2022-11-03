# Site Reliability Engineering Test

This document contains a technical implementation using Packer and Terraform on AWS.

## Description

Packer is used to create an Aws Ami, with an http server installed in a defined region with a defined name (image name), creating a manifest file containing information about this aws ami image.

Terraform reads the packer manifest, to use it as an image for web servers.

Terraform will create an infrastructure containing:
 - Vpc and subnets (public and private)
 - Internat Gateway for routes on public subnets
 - NatGateway for routes on private subnets
 - Elastic Ip for NatGateway
 - Key pair for EC2 instances (SSH access)
 - Bastion Host (One EC2 instance, t2.micro) on public subnet
 - Another Elastic Ip, for Bastion Host
 - Web Servers (EC2 instances, one for each private subnet, without a Public Ip, t2.micro)
 - Application LoadBalancer to access http port from Web Servers on Private subnets
 
 ### Explanation

 To run this IaC, you must configure the region, Network CIDR for VPC, and the number of subnets (half of them will be public and half private).
 Tags for all resources and a Name for each one. The Name variable will be used as a prefix for each resource, and the rest of the name will represent a resource and its count number when IaC creates more than one. And the name of Ami image.

 ## Configuration

 Considering the explanation above, two configuration files need to be visited before start:

 .\packer\packer.pkvars.hcl
 
 .\terraform\terraform.tfvars

 For Aws access this project does not provide any way to put Aws Key and Secret, then it is a requirement, to define it in Aws Cli configuration.

 ## Requirements

 - Packer
 - Terraform
 - Aws Cli
 - Aws Account
 - GNU Make

 ## How to Run

 After configurations, the infrastructure can be built using a simple "make apply" from the base directory (same directory as the Makefile file).
 To destroy the infrastructure created a simple "make destroy" command.
 
