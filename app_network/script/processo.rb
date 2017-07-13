processo = `ps -ef | grep loop.sh`
array_processo = processo.to_s.scan(/\w+/)
p array_processo
#matar processo 
`kill #{array_processo[1]}`
`sleep 5`

`.//home/carlos/tcc/app_network/script/loop.sh`
