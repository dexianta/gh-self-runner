######################
# install docker
######################
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
######################
# install miniconda
######################
set +e
FILE="/tmp/miniconda.sh"
if [[ -f "$FILE" ]]; then
    echo "$FILE exists."
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $FILE
    bash $FILE -b
fi
######################
# install golang
######################
GO_FILE="./go1.17.8.linux-amd64.tar.gz"
if [[ -f "$GO_FILE" ]]; then
    echo "GO FILE EXISTS"
else
    wget https://go.dev/dl/go1.17.8.linux-amd64.tar.gz
fi
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.8.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc 


######################
# install build essential
######################
sudo apt install build-essential

######################
# install swaggo
######################
go install github.com/swaggo/swag/cmd/swag@latest
