# -- script relatedcpid=$$
MEMORY_LIMIT=1G
CGROUP_NAME=benchtest1
ROCKSDB_DATA_DIR=/mnt/data
ROCKSDB_INSTALL_DIR=/mnt/rocksdb-7.7.3

# -- bench argument
ENV_VARS="\
  JOB_ID=$JOB_ID \
  DB_DIR=$ROCKSDB_DATA_DIR \
  WAL_DIR=$ROCKSDB_DATA_DIR \
  CACHE_SIZE=536870912 \
  WRITE_BUFFER_SIZE_MB=128\
  COMPRESSION_TYPE=none \
  LEVEL0_FILE_NUM_COMPACTION_TRIGGER=4 \
  PER_LEVEL_FANOUT=10 \
  MAX_BYTES_FOR_LEVEL_BASE_MB=512"