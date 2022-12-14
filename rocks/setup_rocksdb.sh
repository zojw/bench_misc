wget https://github.com/facebook/rocksdb/archive/refs/tags/v7.7.3.tar.gz -P /mnt
cd /mnt
mkdir data
tar zxvf v7.7.3.tar.gz
cd /mnt/rocksdb-7.7.3
make static_lib -j 8
DEBUG_LEVEL=0 make db_bench