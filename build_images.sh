docker build -t slurm-swarm-base:19.05.4 ./base
docker build -t slurm-swarm-worker:19.05.4 ./worker
docker build -t slurm-swarm-controller:19.05.4 ./controller
