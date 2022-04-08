# for-developer-gcp-code-editor
docker build -t stefanbertos/gcp-code-editor .

docker volume create code-editor-volume

docker run -p 127.0.0.1:8080:8080 --volume "code-editor-volume:/home/coder" --user "coder" -e "DOCKER_USER=coder" -e "PASSWORD=12345" -it stefanbertos/gcp-code-editor

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
startup-script:
sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo fsck.ext4 -tvy /dev/sdb
sudo mkdir -p /home/projects
sudo mount -t ext4 -O discard,defaults /dev/sdb /home/projects
sudo wget https://github.com/coder/code-server/releases/download/v4.2.0/code-server-4.2.0-linux-amd64.tar.gz
sudo tar -xvzf code-server-4.2.0-linux-amd64.tar.gz
sudo cp -r code-server-4.2.0-linux-amd64 /usr/lib/code-server
sudo ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server
sudo echo "[Unit]" > /lib/systemd/system/code-server.service
sudo echo "Description=code-server" >> /lib/systemd/system/code-server.service
sudo echo "After=nginx.service" >> /lib/systemd/system/code-server.service
sudo echo "[Service]" >> /lib/systemd/system/code-server.service
sudo echo "Type=simple" >> /lib/systemd/system/code-server.service
sudo echo "Environment=PASSWORD=secure-password" >> /lib/systemd/system/code-server.service
sudo echo "ExecStart=/usr/bin/code-server --bind-addr 0.0.0.0:8080 --user-data-dir /home/projects --auth password" >> /lib/systemd/system/code-server.service
sudo echo "Restart=always" >> /lib/systemd/system/code-server.service
sudo echo "[Install]" >> /lib/systemd/system/code-server.service
sudo echo "WantedBy=multi-user.target" >> /lib/systemd/system/code-server.service
sudo systemctl daemon-reload
sudo systemctl start code-server
sudo systemctl enable code-server
sudo systemctl status code-server
sudo code-server --install-extension esbenp.prettier-vscode
sudo code-server --install-extension redhat.vscode-yaml
sudo code-server --install-extension ms-python.python
sudo code-server --install-extension redhat.java
sudo code-server --install-extension Betajob.modulestf
sudo code-server --install-extension redhat.vscode-xml
sudo code-server --install-extension hediet.vscode-drawio-insiders-build
sudo code-server --install-extension richardwillis.vscode-gradle
sudo code-server --install-extension vscjava.vscode-java-pack
sudo code-server --install-extension vscjava.vscode-maven
sudo code-server --install-extension pivotal.vscode-spring-boot
sudo code-server --install-extension pivotal.vscode-boot-dev-pack
sudo code-server --install-extension vscjava.vscode-spring-initializr
sudo code-server --install-extension vscjava.vscode-spring-boot-dashboard