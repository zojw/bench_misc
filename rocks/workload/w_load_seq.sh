source ../config.sh

keys=25000000
threads={$1:-1}

env -S "$ENV_VARS" THREADS=$threads NUM_KEYS=$keys bash ${ROCKSDB_INSTALL_DIR}/tools/benchmark.sh fillseq_disable_wal,flush_mt_l0