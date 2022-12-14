source ../config.sh
source ../limit_res.sh

keys=25000000
threads={$1:-1}

cd ${ROCKSDB_INSTALL_DIR}
env -S "$ENV_VARS" THREADS=$threads NUM_KEYS=$keys bash tools/benchmark.sh fillseq_disable_wal,waitforcompaction
