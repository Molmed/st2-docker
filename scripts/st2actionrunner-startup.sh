#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc python

# Make dummy config file for snpseq_packs
sh -c '/opt/stackstorm/virtualenvs/snpseq_packs/bin/python /opt/stackstorm/packs/snpseq_packs/scripts/generate_example_config_from_schema.py /opt/stackstorm/packs/snpseq_packs/config.schema.yaml > /opt/stackstorm/packs/snpseq_packs/snpseq_packs.yaml'

# Create symlink to dummy pack config
ln -fs /opt/stackstorm/packs.dev/snpseq_packs.yaml /opt/stackstorm/configs/snpseq_packs.yaml