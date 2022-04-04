# Start from the code-server Debian base image
FROM codercom/code-server:4.2.0

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Install jdk
RUN sudo apt install -y openjdk-11-jdk

# Install node
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install -y npm

# Install extensions
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension redhat.vscode-yaml
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension redhat.java
RUN code-server --install-extension Betajob.modulestf
RUN code-server --install-extension redhat.vscode-xml
RUN code-server --install-extension hediet.vscode-drawio-insiders-build
RUN code-server --install-extension richardwillis.vscode-gradle
RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension vscjava.vscode-maven
RUN code-server --install-extension pivotal.vscode-spring-boot
RUN code-server --install-extension pivotal.vscode-boot-dev-pack
RUN code-server --install-extension vscjava.vscode-spring-initializr
RUN code-server --install-extension vscjava.vscode-spring-boot-dashboard

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]