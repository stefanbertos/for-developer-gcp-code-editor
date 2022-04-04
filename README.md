# for-developer-gcp-code-editor
docker build -t stefanbertos/gcp-code-editor .

docker volume create code-editor-volume

docker run -p 127.0.0.1:8080:8080 --volume "code-editor-volume:/home/coder" --user "coder" -e "DOCKER_USER=$USER" -e "PASSWORD=12345" -it stefanbertos/gcp-code-editor

docker push stefanbertos/gcp-code-editor:latest

skusit manualne a potom cez command

gcloud compute instances create-with-container code-editor-vm --container-image stefanbertos/gcp-code-editor:latest --machine-type n1-standard-1 --create-disk name=data-disk,size=10GB,device-name=code-editor-data,auto-delete=false,type=pd-standard --zone europe-west3-a
--container-env [DOCKER_USER=$USER,PASSWORD=12345] --network-interface subnet-name=<subnet name>,nat-ip-version=ipv4 \
--service-account-name default-sa \ --public-ip  --container-restart-policy=never

--container-env=SCHEMA_REGISTRY_HOST_NAME=localhost,
SCHEMA_REGISTRY_LISTENERS=http://0.0.0.0:8081,SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS=SASL_SSL://CCLOUD_BROKER_HOST:9092,
SCHEMA_REGISTRY_KAFKASTORE_SECURITY_PROTOCOL=SASL_SSL,
SCHEMA_REGISTRY_KAFKASTORE_SASL_JAAS_CONFIG=org.apache.kafka.common.security.plain.PlainLoginModule\ 
required\ username=\"CCLOUD_USERNAME\"\ password=\"CCLOUD_PASSWORD\"\;,SCHEMA_REGISTRY_KAFKASTORE_SASL_MECHANISM=PLAIN,SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL=INFO \
     

