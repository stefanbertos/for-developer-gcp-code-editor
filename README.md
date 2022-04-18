# for-developer-gcp-code-editor
docker build -t stefanbertos/gcp-code-editor .
docker volume create code-editor-volume
docker run -p 127.0.0.1:80:80 --volume "code-editor-volume:/home/coder" --user "coder" -e "DOCKER_USER=coder" -e "PASSWORD=12345" -it stefanbertos/gcp-code-editor
docker push stefanbertos/gcp-code-editor:latest

--------------------------------------------------------------
prepare the attached disk created manually
sudo lsblk
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
---------------------------------------------------------------
instance creations as:
Zone europe-west3-c
Machine type e2-medium
HTTP traffic On
Network interfaces default 35.207.129.186 (Ephemeral)
Storage 10GB ubuntu-2004-focal-v20220404 SSD persistent disk Boot, read/write, keep
Additional disks 20GB code-editor-permament-disk SSD persistent disk, read/write, keep
Cloud API access scopes - only compute engine


- network endpoint
- load balancer http
- load balancer https

check terrafom load balancers - github

https://cloud.google.com/load-balancing/docs/https

https://cloud.google.com/load-balancing/docs/backend-service
https://cloud.google.com/load-balancing/docs/negs#zonal-neg
https://cloud.google.com/load-balancing/docs/health-checks#gcloud_10

gcloud compute health-checks create
gcloud compute health-checks describe

gcloud compute health-checks list --global
gcloud compute health-checks list --regions=REGION_LIST
gcloud compute health-checks describe NAME --global
gcloud compute health-checks describe NAME --region=REGION

gcloud compute backend-services get-health NAME --global --format=get(name, healthStatus)
gcloud compute backend-services get-health NAME --region=REGION --format=get(name, healthStatus)

https://github.com/terraform-google-modules/terraform-google-lb-http

https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/modules/http-load-balancer/core-concepts.md#how-do-you-configure-a-custom-domain

https://cloud.google.com/load-balancing/docs/https/ext-http-lb-tf-module-examples


now testing https://github.com/terraform-google-modules/terraform-google-lb-http/tree/master/examples/https-redirect
zda sa ze to funguje ale trva dlouho

https://cloud.google.com/iap/docs/load-balancer-howto?hl=cs&_ga=2.152650621.-576537936.1641501089&_gac=1.248952053.1649613585.Cj0KCQjwgMqSBhDCARIsAIIVN1VduDsY_7qN8EV1_HwY_IajvZq9tteB3bjY49ycjXnNQluBokUxTw0aAiXWEALw_wcB#firewalls

prepare all in terraform

in google cloud shell

gcloud auth application-default login
gcloud config get-value project
export GOOGLE_PROJECT=for-developers-343319

terraform init
terraform apply 
terraform destroy