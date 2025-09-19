#!/bin/bash

vagrant up
sleep 20

docker run --rm -it \
  -e ANSIBLE_SSH_ARGS="-F none" \
  -e ANSIBLE_INVENTORY=/project/inventory \
  -v $PWD:/project \
  -v $HOME/.ssh:/root/.ssh \
  autobase/automation:2.3.2 \
    ansible-playbook deploy_pgcluster.yml -u vagrant --ask-pass --become-user=root -b