#!/bin/bash

# Install dependencies
apt-get update && apt-get install -y gcc curl vim

## Install snpseq-packs
ln -fns /opt/stackstorm/packs.dev /opt/stackstorm/packs/snpseq_packs

## Copy dummy genologics config to home of root user (required for unit tests)
cp /opt/stackstorm/packs/snpseq_packs/utils/.genologicsrc /root/

# Reload to recognize snpseq_packs
st2ctl reload

## Load snpseq_packs packs
st2 run packs.load packs=snpseq_packs register=all

## Make virtualenv for snpseq_packs
st2 run packs.setup_virtualenv packs=snpseq_packs
/opt/stackstorm/virtualenvs/snpseq_packs/bin/pip install cryptography==38.0.4
# Make dummy config file for snpseq_packs
sh -c '/opt/stackstorm/virtualenvs/snpseq_packs/bin/python /opt/stackstorm/packs/snpseq_packs/scripts/generate_example_config_from_schema.py /opt/stackstorm/packs/snpseq_packs/config.schema.yaml > /opt/stackstorm/packs/snpseq_packs/snpseq_packs.yaml'

# Create symlink to dummy pack config
ln -fs /opt/stackstorm/packs.dev/snpseq_packs.yaml /opt/stackstorm/configs/snpseq_packs.yaml

## Make sure config is loaded
st2ctl reload --register-configs

## Make sure rules are disabled
/opt/stackstorm/packs/snpseq_packs/scripts/rule_switch disable
