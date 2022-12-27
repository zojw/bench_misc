source ../config.sh
source ../limit_res.sh

keys=40000000
threads={$1:-1}

cd ${INSTALL_DIR}
env -S "$ENV_VARS" THREADS=$threads NUM_KEYS=$keys bash scripts/benchmark.sh bulkload,waitforreclaiming
