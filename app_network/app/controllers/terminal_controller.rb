class TerminalController < ApplicationController
require 'net/ssh'
  def login
    form                        = params[:form]
    @equipamento                = Equipamento.find_by_id form[:equipamento_id]
  end

  def insert
    form                        = params[:form]
#    equipamento                 = Equipamento.find_by_id form[:equipamento_id]
#    acesso                      = Acesso.find_by_id form[:acesso_id]
    equipamento                 = Equipamento.find_by_id form[:equipamento_id]
    acesso                      = Acesso.find_by_id form[:acesso_id]

    @@hostname = equipamento.ip
    if not acesso.eql? nil
      @@username = acesso.login
      @@password = acesso.senha
    else
      @@username = form[:login]
      @@password = form[:senha]
    end
    redirect_to :controller => '/terminal', :action => 'ssh'
  end

  def ssh
    @hostname = @@hostname
    @username = @@username
    @password = @@password
    form                        = params[:form]
    if form.blank?
     @cmd = 'pwd'
    else
      if form[:comando].eql? 'install snmp'
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} apt-get install -y snmp snmp-mibs-downloader snmpd libsnmp-dev`
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} rm -rf /etc/snmp/snmp.conf`
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} rm -rf /etc/snmp/snmpd.conf`
        `sshpass -p "#{@password}" scp /home/carlos/tcc/app_network/arquivos/snmp.txt #{@username}@#{@hostname}:/etc/snmp/snmp.conf`
        `sshpass -p "#{@password}" scp /home/carlos/tcc/app_network/arquivos/snmpd.txt #{@username}@#{@hostname}:/etc/snmp/snmpd.conf`
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} download-mibs`
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} service snmpd restart`
        `sshpass -p "#{@password}" ssh -o StrictHostKeyChecking=no #{@username}@#{@hostname} init 6`
         flash[:notice] = "Instalado Protocolo SNMP"
#        scp /etc/snmp/snmp.conf

#        download-mibs

#        service snmpd restart
        @cmd = 'pwd'
      else
        @cmd = form[:comando]
      end
    end
      local = 'pwd'
      begin
	ssh = Net::SSH.start(@hostname, @username, :password => @password)
	@res = "#{ssh.exec!(@cmd.force_encoding("UTF-8"))}"
	@local = "#{ssh.exec!(local.force_encoding("UTF-8"))}"
	ssh.close 
      rescue
        flash[:error] = "Não foi Possivel conectar-se: #{@hostname}"
      end
  end
end
