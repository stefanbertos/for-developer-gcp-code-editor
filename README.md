#Guide
Either in Google cloud shell or with local SDK

gcloud auth application-default login
gcloud config get-value project
export GOOGLE_PROJECT=for-developers-343319

Install Terraform locally if not present -> https://learn.hashicorp.com/tutorials/terraform/install-cli

As we are using non standard provider we need to install it manually.
see https://github.com/mhumeSF/terraform-provider-namedotcom/issues/8
On the windows machine you can create in the current directory terraform.d/plugins and structure
registry.namedotcom.local/namedotcom/namedotcom/1.1.1./windows_amd64/terraform-provider-namedotcom.exe

to get the username and token go to https://www.name.com/account/settings/api

terraform init
terraform apply 
terraform destroy
