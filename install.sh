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
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh
######################
# install golang
######################
wget https://go.dev/dl/go1.17.8.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.8.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin


######################
# install make
######################
sudo apt install make

######################
# install swaggo
######################
go install github.com/swaggo/swag/cmd/swag@latest
