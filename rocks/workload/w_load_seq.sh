source ../config.sh

keys=25000000
threads={$1:-1}

THREADS=$threads NUM_KEYS=$keys bash ${ROCKSDB_INSTALL_DIR}/tools/benchmark.sh fillseq_disable_wal &> /tmp/benchsh.txt

grep -A1 "^ops_sec" | tail -1