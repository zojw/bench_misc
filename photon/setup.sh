wget https://github.com/photondb/photondb/archive/refs/heads/main.zip -P /mnt
git clone
cd /mnt
mkdir pdata
unzip main.zip
cd /mnt/photondb-main

sudo apt-get install -y cmake libclang-dev

export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh -s -- -q -y
source "$HOME/.cargo/env"
cat >~/.cargo/config <<EOF
[source.crates-io]
# To use sparse index, change 'rsproxy' to 'rsproxy-sparse'
replace-with = 'rsproxy'
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"
[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"
[net]
git-fetch-with-cli = true
EOF

cargo b -r