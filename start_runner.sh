mkdir actions-runner && cd actions-runner
curl -o actions-runner-osx-x64-2.289.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.289.1/actions-runner-osx-x64-2.289.1.tar.gz
echo "53e7457cc15e401c91ea685f8f0ea1eacc8efb2340633e27637603bb6a3d0ccd  actions-runner-osx-x64-2.289.1.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-osx-x64-2.289.1.tar.gz

# more steps need to be taken here
./config.sh --url https://github.com/benshi-ai --token AN5B6KPSAWJFIUZCQH5QF7TCI3MXK 
./run.sh
