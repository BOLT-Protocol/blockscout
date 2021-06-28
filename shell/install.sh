#!/bin/bash

usage() { 
  echo "Usage: $0 [-h db_host(require)] [-p db_password(require)] [-w wsapi(require)] [-r rpcapi(require)]"
  echo "  -h : postgres host";
  echo "  -p : postgres password";
  echo "  -w : eth node websocket api, ex: https://127.0.0.1";
  echo "  -r : eth node rpc https api, ex: ws://127.0.0.1";
  
  exit 1;
}

while getopts "h:p:w:r:" o; do
    case "${o}" in
        h)
            h=${OPTARG}
            ;;
        p)
            p=${OPTARG}
            ;;
        w)
            wsapi=${OPTARG}
            ;;
        r)
            rpcapi=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${h}" ] || [ -z "${p}" ] || [ -z "${wsapi}" ] || [ -z "${rpcapi}" ]; then
    usage
fi

### Setup Swap ###
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

### Install epel-release ###
sudo yum -y install epel-release wget screen

### Install Erlang ###
wget https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_23.2.1-1~centos~7_amd64.rpm
sudo yum install -y wxGTK-devel unixODBC-devel
sudo yum install -y esl-erlang_23.2.1-1~centos~7_amd64.rpm

### Install Elixir ###
wget https://github.com/elixir-lang/elixir/releases/download/v1.10.0/Precompiled.zip
sudo yum install -y unzip
sudo mkdir /opt/elixir
sudo unzip -o /opt/elixir Precompiled.zip
sudo sh -c 'echo "export PATH=\"$PATH:/opt/elixir/bin\"" >> /etc/profile'
source /etc/profile

### Install Nodejs ###
wget https://nodejs.org/dist/v15.8.0/node-v15.8.0-linux-x64.tar.xz
tar -xf node-v15.8.0-linux-x64.tar.xz
mv node-v15.8.0-linux-x64 nodejs
mkdir .bin
mv nodejs .bin/
echo 'export PATH="/home/centos/.bin/nodejs/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

### Install Library ###
sudo yum --enablerepo=epel group install -y "Development Tools" gmp-devel
sudo yum -y install inotify-tools gcc-c++ libtool make git

### Install Rust ###
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# source: https://github.com/rust-lang/docker-rust/blob/e9fa22548981365ced90bc22d9173e2cf6b96890/1.53.0/buster/Dockerfile
RUSTUP_HOME=/usr/local/rustup
CARGO_HOME=/usr/local/cargo
PATH=/usr/local/cargo/bin:$PATH
RUST_VERSION=1.53.0
rustArch='x86_64-unknown-linux-gnu'; rustupSha256='3dc5ef50861ee18657f9db2eeb7392f9c2a6c95c90ab41e45ab4ca71476b4338' ;
url="https://static.rust-lang.org/rustup/archive/1.24.3/${rustArch}/rustup-init"; \
wget "$url"
echo "${rustupSha256} *rustup-init" | sha256sum -c -
chmod +x rustup-init
./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}
rm rustup-init
rustup --version
cargo --version
rustc --version
source $HOME/.cargo/env

### Setup blockscout ###
git clone https://github.com/BOLT-Protocol/blockscout.git
cd blockscout

### Setup blockscout - gen secret ###
mix deps.get
mix phx.gen.secret >> tmp
SECRET=$(tail -n 1 ./tmp)

### Setup blockscout - set env ###
echo "# blockscout env" >> ~/.bashrc
echo "export DATABASE_URL=\"postgresql://postgres:${p}@${h}:5432/blockscout\"" >> ~/.bashrc
echo "export DB_HOST=${h}" >> ~/.bashrc
echo "export DB_PASSWORD=${p}" >> ~/.bashrc
echo "export DB_PORT=5432" >> ~/.bashrc
echo "export DB_USERNAME=postgres" >> ~/.bashrc
echo "export SECRET_KEY_BASE=\"${SECRET}\"" >> ~/.bashrc
echo "export ETHEREUM_JSONRPC_VARIANT=geth" >> ~/.bashrc
echo "export ETHEREUM_JSONRPC_HTTP_URL=\"${wsapi}\"" >> ~/.bashrc
echo "export ETHEREUM_JSONRPC_WS_URL=\"${rpcapi}\"" >> ~/.bashrc
echo "export SUBNETWORK=MAINNET" >> ~/.bashrc
echo "export PORT=80" >> ~/.bashrc
echo "export COIN=\"TideBit\"" >> ~/.bashrc
echo "export LOGO=https://raw.githubusercontent.com/BOLT-Protocol/blockscout/tidebit/apps/block_scout_web/assets/static/images/blockscout_logo.svg" >> ~/.bashrc
echo "export CHAIN_ID=8017" >> ~/.bashrc
echo "export SHOW_PRICE_CHART=false" >> ~/.bashrc
echo "export SHOW_TXS_CHART=true" >> ~/.bashrc
echo "export ENABLE_TXS_STATS=true" >> ~/.bashrc
echo "export HEART_BEAT_TIMEOUT=20" >> ~/.bashrc
echo "export HEART_COMMAND=\"cd /home/centos/blockscout; screen -d -m mix phx.server\""
source ~/.bashrc
rm tmp
sudo setcap cap_net_bind_service=+ep /usr/lib/erlang/erts-11.1.5/bin/beam.smp

### Setup blockscout - install & compile ###
mix do deps.get
mix do local.rebar --force
mix do deps.compile
mix do compile

### Setup blockscout - migrate ###
mix do ecto.drop, ecto.create, ecto.migrate

### Setup blockscout - web ui dependency & build
cd apps/block_scout_web/assets
npm install && node_modules/webpack/bin/webpack.js --mode production

### Setup blockscout - deploy builded web
cd ..
mix phx.digest

### Setup blockscout - enable http
mix phx.gen.cert blockscout blockscout.local

sudo sed -i "s/localdomain4$/localdomain4 blockscout.local/g" /etc/hosts
sudo sed -i "s/localdomain6$/localdomain6 blockscout.local/g" /etc/hosts


### Setup blockscout - fix Error: ENOSPC
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
screen -d -m mix phx.server
