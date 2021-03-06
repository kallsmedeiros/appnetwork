#!/usr/bin/ruby

###################################################################################################################################################
#                                                       CARREGAR GEM POSTGRESQL                                                                   #
###################################################################################################################################################

require 'pg'

###################################################################################################################################################
#                                                       INICIO  LENDO  ARQUIVOS                                                                   #
###################################################################################################################################################

#RELACIONAMENTO DO ALERTA COM MONITORAMENTO
#ARQUIVO CARREGA O ID DO MONITORAMENTO PARA PODER INPUTAR DIRETO NA TABELA
monitoramento_id = File.readlines('/home/carlos/tcc/app_network/script/monitoramento_id.txt')
id = monitoramento_id[0].to_s.scan(/\w+/)
monitoramento_id = id[0].to_i
puts "Monitoramento Id: #{monitoramento_id}"

#COLETAR INFORMACOES DOS LIMITES DOS EQUIPAMENTOS ESTABERECIDOS PREVIAMENTE
alerta = File.readlines('/home/carlos/tcc/app_network/script/alerta.txt')
i = 0
alerta_ip_address = []
alerta_equipamento_id = []
alerta_uso_cpu_usuario = []
alerta_uso_cpu_sistema = []
alerta_swap_disponivel = []
alerta_ram_disponivel = []
alerta_disco_disponivel = []
alerta_upload = []
alerta_download = []
alerta_porcentagem_banda = []
alerta_taxa_utilizacao = []

alerta.each do
  var = alerta[i].to_s.scan(/\w+/)
  alerta_equipamento_id[i]   = var[0].to_i
  alerta_ip_address[i]    = "#{var[1]}.#{var[2]}.#{var[3]}.#{var[4]}"
  alerta_uso_cpu_usuario[i]  = var[5].to_i
  alerta_uso_cpu_sistema[i]  = var[6].to_i
  alerta_swap_disponivel[i]  = var[7].to_i
  alerta_ram_disponivel[i]   = var[8].to_i
  alerta_disco_disponivel[i] = var[9].to_i
  alerta_upload[i]           = var[10].to_i
  alerta_download[i]         = var[11].to_i
  alerta_porcentagem_banda[i]= var[12].to_i
  alerta_taxa_utilizacao[i]  = var[13].to_i
  i = i+1
end

#LER IPs PARA FAZER A VARREDURA VIA SNMP
arquivo = File.readlines('/home/carlos/tcc/app_network/script/ip.txt')
i = 0
ip_address = []
equipamento_id = []
arquivo.each do 
  var = arquivo[i].to_s.scan(/\w+/)
  equipamento_id[i]= var[0].to_i
  ip_address[i] = "#{var[1]}.#{var[2]}.#{var[3]}.#{var[4]}"
  i = i+1
end

#CARREGA EMAIL PARA ENVIAR EM CASO DE ALERTA

emails = File.readlines('/home/carlos/tcc/app_network/script/email.txt')
array_email = []
emails.each do |email|
  j = 0
  e = ''
  while email[email.size-1] != email[j] do
  e << email[j]
  j = j+1
  end
  array_email << e
end
puts "E-mails: #{array_email}"

###################################################################################################################################################
#                                                         FIM  LENDO  ARQUIVOS                                                                    #
###################################################################################################################################################

###################################################################################################################################################
#INICIO                                              CARREGA OS OBJETOS ID DO PROTOCOLO                                                           #
###################################################################################################################################################
obj_descricao = ["Porcentagem de uso de CPU pelos usuários",
                 "Tempo absoluto de uso de CPU pelos usuários",
                 "Porcentagem de uso de CPU pelo sistema",
                 "Tempo absoluto de uso de CPU pelo sistema",
                 "Porcentagem de CPU ociosa",
                 "Tempo absoluto de CPU ociosa",
                 "Tamanho total da memória de troca (SWAP)",
                 "Espaço disponível na memória de troca (SWAP)",
                 "Total de memória RAM",
                 "Total de memória RAM utilizada",
                 "Total de memória RAM disponível",
                 "Total de memória CACHE",
                 "Tamanho total do disco (Kbytes)",
                 "Espaço disponível no disco",
                 "Espaço utilizado no disco",
                 "Sistema Iniciado"]

obj_id = ['.1.3.6.1.4.1.2021.11.9.0',
          '.1.3.6.1.4.1.2021.11.50.0',
          '.1.3.6.1.4.1.2021.11.10.0',
          '.1.3.6.1.4.1.2021.11.52.0',
          '.1.3.6.1.4.1.2021.11.11.0',
          '.1.3.6.1.4.1.2021.11.53.0',
          '.1.3.6.1.4.1.2021.4.3.0',
          '.1.3.6.1.4.1.2021.4.4.0',
          '.1.3.6.1.4.1.2021.4.5.0',
          '.1.3.6.1.4.1.2021.4.6.0',
          '.1.3.6.1.4.1.2021.4.11.0',
          '.1.3.6.1.4.1.2021.4.15.0',
          '.1.3.6.1.4.1.2021.9.1.6.1',
          '.1.3.6.1.4.1.2021.9.1.7.1',
          '.1.3.6.1.4.1.2021.9.1.8.1',
          '.1.3.6.1.2.1.1.3.0']
###################################################################################################################################################
#FIM                                                 CARREGA OS OBJETOS ID DO PROTOCOLO                                                           #
###################################################################################################################################################

###################################################################################################################################################
#INICIO                                         APLICA COMANDO PARA EXTRAIR VALOR DO PROTOCOLO                                                    #
###################################################################################################################################################

rocommunity = 'appnetwork'
banco = []
ip = 0
ip_address.each do
bd = []
bd << "#{ip_address[ip]} "
index = 0
puts ''
puts "#{ip_address[ip]}"

# Teste de conexao otimizacao de tempo de aplicacao do script
  conectado = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} #{obj_id[1]}`
  if not conectado.eql? ""
    obj_id.each do |obj|
      cpu = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} #{obj}`

      b = cpu.scan(/\w+/)
      c = b.length
      if not obj_descricao[index].eql? "Sistema Iniciado"
        if not b[c-1].eql? 'kB'
          puts "#{obj_descricao[index]}:#{b[c-1]}"
          bd << "#{b[c-1]} "
        end
        if b[c-1].eql? 'kB'
          puts "#{obj_descricao[index]}:#{b[c-2]} #{b[c-1]}"
          bd << "#{b[c-2]}#{b[c-1]} " 
        end
      else
        tempo = "#{b[c-4]}:#{b[c-3]}:#{b[c-2]}:#{b[c-1]}"
        puts "#{obj_descricao[index]}:#{tempo}"
        bd << "#{tempo} "
      end
      index=index+1
    end
# MONITORAMENTO DE BANDA
	tempo = 10
	ifInOctets1   = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} 1.3.6.1.2.1.2.2.1.10` 
	ifOutOctets1  = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} 1.3.6.1.2.1.2.2.1.16`
	`sleep #{tempo}`
	ifInOctets2   = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} 1.3.6.1.2.1.2.2.1.10` 
	ifOutOctets2  = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} 1.3.6.1.2.1.2.2.1.16`
	ifSpeed       = `snmpwalk -c #{rocommunity} -v1 #{ip_address[ip]} 1.3.6.1.2.1.2.2.1.5`

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
	porcentagem_utilizacao = total/velocidade
        taxa_utilizacao = download+upload

	puts "Quantidade de interfaces exitentes:#{tamanho+1}"
	puts "Download:#{download}kbps"
	puts "Upload:  #{upload}kbps"
	puts "Porcentagem de Utilizacao:#{porcentagem_utilizacao}%"
	puts "taxa de Utilizacao:#{taxa_utilizacao} kbps"
        bd << upload.to_s
        bd << download.to_s
        bd << porcentagem_utilizacao.to_s
        bd << taxa_utilizacao
  else
    obj_id.each do 
      bd << " "
    end
      bd << " "
      bd << " "
      bd << " "
      bd << " "
  end
  bd << equipamento_id[ip]
  p "##################################################################################################################################################"
  ip = ip+1
  banco << bd
end

###################################################################################################################################################
#FIM                                            APLICA COMANDO PARA EXTRAIR VALOR DO PROTOCOLO                                                    #
###################################################################################################################################################

puts ''
p banco
puts ''

###################################################################################################################################################
#INICIO                                         FORMATANDO FORMATO DA STRING PARA IMPUTAR NO BANCO                                                #
###################################################################################################################################################

banco.each do |bd|
ip = "'""#{bd[0].strip}""'"
uso_cpu_usuario = "'""#{bd[1].strip}""'"
tempo_absoluto_cpu_usuario = "'""#{bd[2].strip}""'"
uso_cpu_sistema = "'""#{bd[3].strip}""'"
tempo_absoluto_cpu_sistema = "'""#{bd[4].strip}""'"
porcentagem_cpu_ociosa = "'""#{bd[5].strip}""'"
tempo_cpu_ociosa = "'""#{bd[6].strip}""'"
tamanho_swap = "'""#{bd[7].strip}""'"
swap_disponivel = "'""#{bd[8].strip}""'"
tamanho_ram = "'""#{bd[9].strip}""'"
ram_utilizada = "'""#{bd[10].strip}""'"
ram_disponivel = "'""#{bd[11].strip}""'"
tamanho_cache = "'""#{bd[12].strip}""'"
tamanho_disco = "'""#{bd[13].strip}""'"
disco_disponivel = "'""#{bd[14].strip}""'"
disco_utilizado = "'""#{bd[15].strip}""'"
sistema_iniciado = "'""#{bd[16].strip}""'"
upload =  "'""#{bd[17]}""'"
download =  "'""#{bd[18]}""'"
if bd[19].eql? "NaN"
  bd[19] = "0"
  porcentagem_utilizacao_banda =  "'""#{bd[19]}""'"
else
  porcentagem_utilizacao_banda =  "'""#{bd[19]}""'"
end
taxa_utilizacao_banda =  "'""#{bd[20]}""'"
equipamento_id =  "'""#{bd[21]}""'"

###################################################################################################################################################
#FIM                                            FORMATANDO FORMATO DA STRING PARA INPUTAR NO BANCO                                                #
###################################################################################################################################################

###################################################################################################################################################
#INICIO                                          VALIDAR VALORES DO MONITORAMENTO E GERAR ALERTAS                                                 #
###################################################################################################################################################

  begin
    time = Time.now
    hora = ''
    hora << "'"
    hora << time.to_s
    hora << "'"
    i = 0
    alerta_descricao = ""
    alerta.each do

      if equipamento_id.eql? "'""#{alerta_equipamento_id[i]}""'" and ip.eql? "'""#{alerta_ip_address[i]}""'"
        if bd[1].eql? " "
          alerta_descricao << "Erro de Conexão: Valores não encontrados, Verifique a conexão"
        else
          if bd[1].strip.to_i >= alerta_uso_cpu_usuario[i].to_i
            alerta_descricao << "CPU, Excedeu o Limite do Usuario: valor cpu:#{bd[1].strip.to_i} Limite: #{alerta_uso_cpu_usuario[i].to_i}% "
          end
          if bd[3].strip.to_i > alerta_uso_cpu_sistema[i].to_i
            alerta_descricao << "CPU, Excedeu o Limite do Sistema: valor cpu:#{bd[3].strip.to_i} Limite: #{alerta_uso_cpu_sistema[i].to_i}% "
          end
          if bd[8].strip.gsub(" kB",'').to_i < alerta_swap_disponivel[i].to_i
            alerta_descricao << "SWAP, Excedeu o Limite: valor SWAP:#{bd[8].strip} Limite: #{alerta_swap_disponivel[i].to_i}kb "
          end
          if bd[11].strip.gsub(" kB",'').to_i < alerta_ram_disponivel[i].to_i
            alerta_descricao << "RAM, Excedeu o Limite: valor RAM:#{bd[11].strip} Limite: #{alerta_ram_disponivel[i].to_i}kb "
          end
          if bd[14].strip.gsub(" kB",'').to_i < alerta_disco_disponivel[i].to_i
            alerta_descricao << "HD, Excedeu o Limite: valor DISCO:#{bd[14].strip} Limite: #{alerta_disco_disponivel[i].to_i}kb "
          end
          if bd[17].strip.gsub("Kbps",'').to_f > alerta_upload[i].to_f
            alerta_descricao << "Upload, Excedeu o Limite: valor Upload: #{bd[17].strip} Limite: #{alerta_upload[i].to_i}Kbps "
          end
          if bd[18].strip.gsub("Kbps",'').to_f > alerta_download[i].to_f
            alerta_descricao << "Download, Excedeu o Limite: valor Download: #{bd[17].strip} Limite: #{alerta_download[i].to_i}Kbps "
          end
          if bd[19].to_s.strip.to_f > alerta_porcentagem_banda[i].to_f
            alerta_descricao << "Banda, Excedeu o Limite: valor taxa de utilizacao: #{bd[19].to_s.strip} Limite: #{alerta_porcentagem_banda[i].to_i}%"
          end
          if bd[20].to_s.strip.to_f > alerta_taxa_utilizacao[i].to_f
            alerta_descricao << "Banda, Excedeu o Limite: valor taxa de utilizacao: #{bd[20].to_s.strip} Limite: #{alerta_taxa_utilizacao[i].to_i}Kbps"
          end

        end
      puts "descricao do alerta:"
      p alerta_descricao
      if not alerta_descricao.eql? ""
        array_email.each do |email|
#        `echo "Alerta Equipamento_id #{equipamento_id} ALERTA: #{alerta_descricao} \n 192.168.25.46/home" | mutt -s "Alerta Equipamento #{equipamento_id}" #{email}`
        end
        puts "E-mail Enviado"
        descricao_alerta = ""
        descricao_alerta << "'"
        descricao_alerta << "#{alerta_descricao}"
        descricao_alerta << "'"
        monitoramentoid = ""
        monitoramentoid << "'"
        monitoramentoid << "#{monitoramento_id+1}"
        monitoramentoid << "'"
        
###################################################################################################################################################
#INICIO                                             SALVAR ALERTA NO BANCO DE DADOS                                                               #
###################################################################################################################################################       
        begin
          con = PG.connect :dbname => 'app_network_development', :host => '127.0.0.1',  :user => 'app_network',
          :password => 'appnetwork'
          con.exec("INSERT INTO alerta (created_at, updated_at, ip, descricao, equipamento_id, monitoramento_id) VALUES (#{hora}, #{hora}, #{ip}, #{descricao_alerta}, #{equipamento_id}, #{monitoramentoid}) RETURNING id;")
           puts "ALERTA!"

        rescue PG::Error => a

        puts a.message

        ensure

        con.close if con
      end
    end
###################################################################################################################################################
#FIM                                                 SALVAR ALERTA NO BANCO DE DADOS                                                              #
###################################################################################################################################################
    end
    i = i+1
  end

###################################################################################################################################################
#FIM                                             VALIDAR VALORES DO MONITORAMENTO E GERAR ALERTAS                                                 #
###################################################################################################################################################

###################################################################################################################################################
#INICIO                                             SALVAR MONITORAMENTO NO BANCO DE DADOS                                                        #
###################################################################################################################################################

    con = PG.connect :dbname => 'app_network_development', :host => '127.0.0.1',  :user => 'app_network',
        :password => 'appnetwork'
    con.exec("INSERT INTO monitoramentos (hora_registro, ip, uso_cpu_usuario, tempo_absoluto_cpu_usuario, uso_cpu_sistema, tempo_absoluto_cpu_sistema, porcentagem_cpu_ociosa, tempo_cpu_ociosa, tamanho_swap, swap_disponivel, tamanho_ram, ram_utilizada, ram_disponivel, tamanho_cache, tamanho_disco, disco_disponivel, disco_utilizado, sistema_iniciado, upload, download, porcentagem_utilizacao_banda, taxa_utilizacao_banda, equipamento_id) VALUES (#{hora}, #{ip}, #{uso_cpu_usuario}, #{tempo_absoluto_cpu_usuario}, #{uso_cpu_sistema}, #{tempo_absoluto_cpu_sistema}, #{porcentagem_cpu_ociosa}, #{tempo_cpu_ociosa}, #{tamanho_swap}, #{swap_disponivel}, #{tamanho_ram}, #{ram_utilizada}, #{ram_disponivel}, #{tamanho_cache}, #{tamanho_disco}, #{disco_disponivel}, #{disco_utilizado}, #{sistema_iniciado}, #{upload}, #{download}, #{porcentagem_utilizacao_banda}, #{taxa_utilizacao_banda}, #{equipamento_id}) RETURNING id;")

    db_name = con.db

    puts "Database name: #{db_name}"

  rescue PG::Error => e

    puts e.message

  ensure

    con.close if con
  end
File.open('/home/carlos/tcc/app_network/script/monitoramento_id.txt', 'w') {|file| file.write(monitoramento_id+1) }
  monitoramento_id = monitoramento_id+1
end
###################################################################################################################################################
#FIM                                                SALVAR MONITORAMENTO NO BANCO DE DADOS                                                        #
###################################################################################################################################################
