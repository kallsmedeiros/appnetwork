#!/bin/bash
while [ 1 ]; do
  ruby /home/carlos/tcc/app_network/script/monitoramento_snmp.rb
  echo "..."
  sleep 60
done
