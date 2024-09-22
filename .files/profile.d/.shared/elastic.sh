# shellcheck shell=bash

bins=( /usr/share/elasticsearch/bin /usr/share/filebeat/bin /usr/share/kibana/bin /usr/share/metricbeat/bin )
for d in "${bins[@]}"; do
  [ -d "$d" ] && PATH+=":$d"
done
unset d bins
