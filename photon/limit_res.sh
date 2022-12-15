mkdir -p /sys/fs/cgroup/$CGROUP_NAME
echo "$MEMORY_LIMIT" > /sys/fs/cgroup/$CGROUP_NAME/memory.max
cpid=$$
echo $cpid > /sys/fs/cgroup/$CGROUP_NAME/cgroup.procs