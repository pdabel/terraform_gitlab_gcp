# Setup Basic single node gitlab instance on GCP

## Objects created:
* vpc
* subnet
* firewall
* public IP
* dns record
* compute instance

## Requires:
* gcp credentials set via GOOGLE_APPLICATION_CREDENTIALS environment variable
* terraform.tfvars file containing variables
* backend.tf for remote state storage

## Variables:
* *region* defaults to europe-west4
* *project* 
* *gitlab_image* needs to have gitlab repo enabled see https://github.com/pdabel/packer
* *dns_zone_name* GCP zone name
* *subnet* CIDR formated address range
* *source_ips* array of cidr formatted ip addresses
