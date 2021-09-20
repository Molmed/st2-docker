#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc python

## Copy dummy genologics config to home of root user (required for some snpseq_packs actions)
cp /opt/stackstorm/packs/snpseq_packs/utils/.genologicsrc /root/
