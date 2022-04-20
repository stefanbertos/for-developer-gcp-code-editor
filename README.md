# Step by step Guide
![diagram](diagram.drawio.png?raw=true "Title")
1. Install Cloud SDK -> go to https://cloud.google.com/sdk/docs/install
2. Authenticate with GCP
```
gcloud auth application-default login
```
3. configure
```
gcloud config get-value project
export GOOGLE_PROJECT=for-developers-343319
```
5. install Terraform locally if not present -> https://learn.hashicorp.com/tutorials/terraform/install-cli
6. install local provider for name.com
As we are using non standard provider we need to install it manually see https://github.com/mhumeSF/terraform-provider-namedotcom/issues/8
On the windows machine you can create in the current directory terraform.d/plugins and structure
registry.namedotcom.local/namedotcom/namedotcom/1.1.1./windows_amd64/terraform-provider-namedotcom.exe
7. get the username and token for domain https://www.name.com/account/settings/api
8. initialize terraform
```
terraform init
```
9. apply changes
```
terraform apply
```
10. enable the IAP manually 
11. test in the browser
12. destroy all
```
terraform destroy
```
