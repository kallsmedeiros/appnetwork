class ConfiguracaoController < ApplicationController

  def index
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def index_do
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    else
    form                        = params[:form]
    if @config.eql? nil
      @config = Configuracao.new
      @config.usuario_id = @online.id
    end
    @config.menu                 = form[:menu]
    @config.tema                 = form[:tema]
    @config.save!
    flash[:notice] = "Configuração Alterada Com Sucesso!"
    redirect_to :controller => '/application', :action => 'logout'
    end
  end

  def sincronizar_monitoramento
    
    equipamentos                = Equipamento.all
    equipamentos_monitorados    = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)
    monitoramento = Monitoramento.order("id DESC").limit 1
    File.open('/home/carlos/tcc/app_network/script/monitoramento_id.txt', 'w') {|file| file.write(monitoramento.first.id)}

      `rm -rf /home/carlos/tcc/app_network/script/alerta.txt`
      File.open('/home/carlos/tcc/app_network/script/alerta.txt', 'w') {|file|
        equipamentos.each do |e|
          file.write("#{e.id} #{e.ip} #{e.uso_cpu_usuario} #{e.uso_cpu_sistema} #{e.swap_disponivel} #{e.ram_disponivel} #{e.disco_disponivel} #{e.upload} #{e.download} #{e.porcentagem_utilizacao_banda} #{e.taxa_utilizacao_banda}\n")
 
        end
      }

      `rm -rf /home/carlos/tcc/app_network/script/ip.txt`
      File.open('/home/carlos/tcc/app_network/script/ip.txt', 'w') {|file|
        equipamentos_monitorados.each do |m|
          file.write("#{m.id} #{m.ip}\n")
        end
      }
    flash[:notice] = "Sincronizado Com Sucesso!"
    redirect_to :controller => '/home', :action => 'index'
  end
end
