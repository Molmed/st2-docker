#!/bin/bash

counter=0
backoff=10

# Install dependencies
apt-get update && apt-get install -y gcc curl vim

# Install snpseq-packs
ln -fns /opt/stackstorm/packs.dev /opt/stackstorm/packs/snpseq_packs

# Copy dummy genologics config to home of root user (required for unit tests)
cp /opt/stackstorm/packs/snpseq_packs/utils/.genologicsrc /root/

# Load snpseq_packs packs
st2 run packs.load packs=snpseq_packs

# Make virtualenv for snpseq_packs
st2 run packs.setup_virtualenv packs=snpseq_packs

# Make sure config is loaded
st2ctl reload --register-configs

# st2client startup and registration
while [ "$counter" -lt 5 ]; do
  ACTIONS=$(st2 action list)
  if [ "$?" -ne 0 ]; then
    echo "unable to reach downstream, will try again in $backoff seconds..."
    sleep "$backoff"
    counter=$((counter+1))
    backoff=$(awk -v backoff="$backoff" 'BEGIN{ printf "%.f", backoff * 1.5 }')
  elif [ "$ACTIONS" == "No matching items found" ]; then
    echo "No packs registered, will register"
    st2 pack register
  else
    echo "actions found st2client ready"
    sleep infinity
  fi
done

echo "Error! No packs were able to be registered due to st2 connect failures! You may need to load them manually."
sleep infinity
