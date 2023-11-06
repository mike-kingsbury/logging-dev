#!/bin/bash

repo_root="$(git rev-parse --show-toplevel)"
cluster_host_file="${repo_root}/setup_scripts/cluster-host"
config_file="${repo_root}/logging-app/logging-configuration.yaml"

if [ ! -f "$cluster_host_file" ]; then
    echo "Error: cluster-host file not found at: $cluster_host_file"
    exit 1
fi

new_url="http://splunk-hec-splunk.apps.$(cat "$cluster_host_file")"

if yq eval --inplace ".spec.outputs[].url = \"$new_url\"" "$config_file" &&
   sed -i '/^  outputs: \[\]/d' "$config_file" &&
   sed -i 's/^---$/&\n/' "$config_file"; then
    echo "Configuration file updated successfully."
else
    echo "Error updating the configuration file."
    exit 1
fi
