# for-developer-gcp-code-editor
docker build -t stefanbertos/gcp-code-editor .

docker volume create code-editor-volume

docker run -p 127.0.0.1:8080:8080 --volume "code-editor-volume:/home/coder" --user "coder" -e "DOCKER_USER=coder" -e "PASSWORD=12345" -it stefanbertos/gcp-code-editor

docker push stefanbertos/gcp-code-editor:latest
