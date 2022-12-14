
# --- install dep

sudo apt update
sudo apt-get install -y apt-transport-https

# install essential tools
sudo apt-get install -y \
    software-properties-common \
    build-essential \
    wget \
    curl \
    vim \
    tmux \
    linux-perf \
    git \
    gdb \
    sshpass \
    numactl \
    tar \
    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libzstd-dev \
    cmake \
    time \
    psmisc \
    jq

# install monitors
# - htop
# - iotop
# - sysstat:            iostat sar psstat
# - smartmontools:      smartctl
# - nvme-cli:           nvme smart-log / list
sudo apt-get install -y \
    htop \
    iotop \
    sysstat \
    smartmontools \
    nvme-cli \
    tcpdump

# ---- mount ssd

DEV=nvme0n1
POINT=mnt

sudo apt-get update
sudo apt-get install -y \
    parted \
    e2fsprogs

parted /dev/${DEV} <<EOF
mklabel gpt
mkpart primary 1 100%
align-check optimal 1
print
quit
EOF

# reload partition table.
partprobe

# display partition info.
fdisk -lu /dev/${DEV}

# make file system for partition.
mkfs -t ext4 /dev/${DEV}p1

cp /etc/fstab /etc/fstab.bak.mount.${DEV}

echo $(blkid /dev/${DEV}p1 | awk '{print $2}' | sed 's/\"//g') /${POINT} ext4 defaults 0 0 >>/etc/fstab

cat /etc/fstab
mount -a
df -h

# ---- config ext4

# /dev/vda1 on / type ext4 (rw,noatime,nodelalloc,errors=remount-ro)
# echo "(rw,noatime,nodelalloc,errors=remount-ro)" | tr -d '()'
function read_mount_options() {
    local dev=$1
    mount | fgrep $dev | awk '{print $NF}' | tr -d '()'
}

function read_mount_point() {
    local dev=$1
    mount | fgrep $dev | awk '{print $3}'
}

function remount() {
    local dev=$1
    local options="$(read_mount_options ${dev})"
    options=( $(echo ${options} | awk -F',' '{ for(i=1;i<=NF;i++) { print $i } }') )
    options=( ${options[*]} nodelalloc noatime )
    options=( $(printf "%s\n" "${options[@]}" | sort -u) )
    options=$(printf ",%s" "${options[@]}")
    options=${options:1}

    local point="$(read_mount_point ${dev})"
    mount -o${options},remount ${point}
}

cp /etc/fstab /etc/fstab.bak

for DEV in $( mount | grep ext4 | awk '{print $1}' | fgrep /dev/ ); do
    PUREDEV=$( echo $DEV | cut -d/ -f3- )
    UUIDIS=$( ls -l /dev/disk/by-uuid/ | fgrep $PUREDEV | awk '{print $9}' )
    remount ${PUREDEV}
    sed -i "/${UUIDIS}/d" /etc/fstab
    left=$(cat /etc/mtab | grep ${DEV} | awk '{ $1=""; print $0 }')
    echo "UUID=${UUIDIS} ${left}" >> /etc/fstab
done

# echo `blkid /dev/vdb1 | awk '{print $2}' | sed 's/\"//g'` /mnt ext4 rw,noatime,nodelalloc,errors=remount-ro 0 0 >> /etc/fstab

systemctl daemon-reload

# --- irqbalance

sudo apt install -y irqbalance
systemctl enable irqbalance
systemctl start irqbalance

# --- config kernel

# config sysctl.conf
cat <<EOF >  /etc/sysctl.d/tikv.conf
net.core.somaxconn = 32768
vm.swappiness = 0
net.ipv4.tcp_syncookies = 0
fs.file-max = 1000000
EOF

sed -i '/net.ipv4.tcp_syncookies = 1/d' /etc/sysctl.conf

# config ulimits
cat <<EOF >>  /etc/security/limits.conf
root        soft        nofile        1048576
root        hard        nofile        1048576
root        soft        stack         10240
EOF

sysctl --system

# --- disable swap

swapoff -a
sed -i 's/^\(.*swap.*\)$/#\1/' /etc/fstab


cat >>/etc/hosts <<EOF
# GitHub Start
140.82.113.4      github.com
140.82.114.4      github.com
140.82.113.4      gist.github.com
140.82.113.6      api.github.com
185.199.108.153   assets-cdn.github.com
185.199.109.153   assets-cdn.github.com
185.199.110.153   assets-cdn.github.com
185.199.111.153   assets-cdn.github.com
199.232.96.133    raw.githubusercontent.com
199.232.96.133    gist.githubusercontent.com
199.232.96.133    cloud.githubusercontent.com
199.232.96.133    camo.githubusercontent.com
199.232.96.133    avatars.githubusercontent.com
199.232.96.133    avatars0.githubusercontent.com
199.232.96.133    avatars1.githubusercontent.com
199.232.96.133    avatars2.githubusercontent.com
199.232.96.133    avatars3.githubusercontent.com
199.232.96.133    avatars4.githubusercontent.com
199.232.96.133    avatars5.githubusercontent.com
199.232.96.133    avatars6.githubusercontent.com
199.232.96.133    avatars7.githubusercontent.com
199.232.96.133    avatars8.githubusercontent.com
199.232.96.133    user-images.githubusercontent.com
# GitHub End
EOF