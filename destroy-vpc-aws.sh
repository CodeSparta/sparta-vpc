#!/bin/bash
project="sparta-vpc"
mkdir aws 2>/dev/null
sudo podman pull docker.io/cloudctl/konductor

sudo podman run -it --rm \
    --name ${project} \
    --volume $(pwd)/aws:/root/.aws:z \
    --entrypoint playbooks/aws/destroy.yml \
    --workdir /root/platform/iac/${project} \
    --volume $(pwd):/root/platform/iac/${project}:z \
  docker.io/cloudctl/konductor $@
