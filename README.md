# for-developer-gcp-code-editor
docker build -t stefanbertos/gcp-code-editor .

docker volume create code-editor-volume

docker run -p 127.0.0.1:8080:8080 --volume "code-editor-volume:/home/coder" --user "coder" -e "DOCKER_USER=coder" -e "PASSWORD=12345" -it stefanbertos/gcp-code-editor

docker push stefanbertos/gcp-code-editor:latest


gcloud compute instances create-with-container code-editor-vm --container-image stefanbertos/gcp-code-editor:latest --machine-type n1-standard-1 --create-disk name=data-disk,size=10GB,device-name=code-editor-data,auto-delete=false,type=pd-standard --zone europe-west3-a
--container-env [DOCKER_USER=$USER,PASSWORD=12345] --network-interface subnet-name=<subnet name>,nat-ip-version=ipv4 \
--service-account-name default-sa \ --public-ip  --container-restart-policy=never --tags http-server


https://cloud.google.com/container-optimized-os/docs/how-to/create-configure-instance#gcloud
