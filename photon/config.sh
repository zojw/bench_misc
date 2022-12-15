# -- script relatedcpid=$$
MEMORY_LIMIT=1G
CGROUP_NAME=benchtest2
DATA_DIR=/mnt/pdata
INSTALL_DIR=/mnt/photondb-main

# -- bench argument
ENV_VARS="\
  JOB_ID=$JOB_ID \
  DB_DIR=$DATA_DIR \
  PAGE_SIZE=16384 \
  CACHE_SIZE=536870912 \
  WRITE_BUFFER_SIZE_MB=128\
  MAX_SPACE_AMP=10"