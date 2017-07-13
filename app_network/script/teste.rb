#!/usr/bin/ruby

p "##################################################################################################################################################"
ip = '127.0.0.1'
tempo = 10
ifInOctets1   = `snmpwalk -c appnetwork -v1 #{ip} 1.3.6.1.2.1.2.2.1.10` 
ifOutOctets1  = `snmpwalk -c appnetwork -v1 #{ip} 1.3.6.1.2.1.2.2.1.16`
`sleep #{tempo}`
ifInOctets2   = `snmpwalk -c appnetwork -v1 #{ip} 1.3.6.1.2.1.2.2.1.10` 
ifOutOctets2  = `snmpwalk -c appnetwork -v1 #{ip} 1.3.6.1.2.1.2.2.1.16`
ifSpeed       = `snmpwalk -c appnetwork -v1 #{ip} 1.3.6.1.2.1.2.2.1.5`

ifIn1 = ifInOctets1.to_s.scan(/\w+/)
ifIn2 = ifInOctets2.to_s.scan(/\w+/)
ifOut1 = ifOutOctets1.to_s.scan(/\w+/)
ifOut2 = ifOutOctets2.to_s.scan(/\w+/)
ifSpeed = ifSpeed.to_s.scan(/\w+/)

interface_in1 = []
interface_in2 = []
interface_out1 = []
interface_out2 = []
interface_speed = []

i = 0
ifIn1.each do |index|
  if index.eql? "IF"
    interface_in1 << ifIn1[i+5].to_f
  end
  if ifIn2[i].eql? "IF"
    interface_in2 << ifIn2[i+5].to_f
  end
  if ifOut1[i].eql? "IF"
    interface_out1 << ifOut1[i+5].to_f
  end
  if ifOut2[i].eql? "IF"
    interface_out2 << ifOut2[i+5].to_f
  end
  if ifSpeed[i].eql? "IF"
    interface_speed << ifSpeed[i+5].to_f
  end

  i=i+1
end
puts "INTERFACES:"
puts "IN1: #{interface_in1}"
puts "IN2: #{interface_in2}"
puts "OUT1: #{interface_out1}"
puts "OUT2: #{interface_out2}"
puts "Speed: #{interface_speed}"

p "##################################################################################################################################################"
tamanho = interface_speed.size-1
velocidade = 0.0
entrada = 0.0
saida   = 0.0
for i in 0..tamanho
  if (interface_in2[i] - interface_in1[i]) > 0.0 or (interface_out2[i] - interface_out1[i]) > 0.0
   entrada = entrada + (interface_in2[i] - interface_in1[i])
   saida   = saida   + (interface_out2[i] - interface_out1[i])
   velocidade = velocidade+ interface_speed[i]
  end
end

download = (((entrada/tempo)*8)/10)/1024
upload   = (((saida/tempo)*8)/10)/1024

total = ((entrada + saida)/tempo)*8
taxa_utilizacao = total/velocidade

puts "Quantidade de interfaces exitentes:#{tamanho+1}"
puts "Download:#{download}kbps"
puts "Upload:  #{upload}kbps"
puts "Porcentagem de Utilizacao:#{taxa_utilizacao}%"
puts "taxa de Utilizacao:#{download+upload} kbps"

