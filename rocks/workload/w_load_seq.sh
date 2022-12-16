source ../config.sh
source ../limit_res.sh

keys=400000000
threads={$1:-1}

cd ${ROCKSDB_INSTALL_DIR}
cat tools/benchmark.sh  | sed '/\-\-report/i       $bench_args \\' > pbenchmark.sh
env -S "$ENV_VARS" THREADS=$threads NUM_KEYS=$keys bash pbenchmark.sh fillseq_disable_wal,waitforcompaction --memtablerep=skip_list --threads=$threads
