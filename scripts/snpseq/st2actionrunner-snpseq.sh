#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc python

## Copy dummy genologics config to home of root user (required for some snpseq_packs actions)
cp /opt/stackstorm/packs.dev/utils/.genologicsrc /root/

# create the known_hosts file and add the snpseq-tester host key
ssh-keyscan -t ecdsa snpseq-tester >> /home/stanley/.ssh/known_hosts
chown -R stanley:stanley /home/stanley/.ssh
