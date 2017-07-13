class EquipamentoController < ApplicationController

  def cadastro_alerta
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    if form[:equipamento_id].eql? ""
      flash[:notice] = "Selecione o equipamento"
      redirect_to :controller => '/equipamento', :action => 'visualizar'
    end
    @equipamento                = Equipamento.find_by_id form[:equipamento_id]
  end
  
  def cadastro_alerta_do
    form                        = params[:form]
    equipamentos                = Equipamento.all
    equipamentos_monitorados    = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)
    equipamento                 = Equipamento.find_by_id form[:equipamento_id]
    
    if not form[:uso_cpu_usuario].eql? "" 
      equipamento.uso_cpu_usuario      = form[:uso_cpu_usuario]
    else
      equipamento.uso_cpu_usuario      = 100
    end

    if not form[:uso_cpu_sistema].eql? ""
      equipamento.uso_cpu_sistema      = form[:uso_cpu_sistema]
    else
      equipamento.uso_cpu_sistema      = 100
    end

    if not form[:swap_disponivel].eql? ""
      equipamento.swap_disponivel      = form[:swap_disponivel]
    else
      equipamento.swap_disponivel      = 0
    end

    if not form[:ram_disponivel].eql? ""
      equipamento.ram_disponivel       = form[:ram_disponivel]
    else
      equipamento.ram_disponivel      = 0
    end

    if not form[:disco_disponivel].eql? ""
      equipamento.disco_disponivel     = form[:disco_disponivel]
    else
      equipamento.disco_disponivel      = 0
    end

    if not form[:upload].eql? ""
      equipamento.upload     = form[:upload]
    else
      equipamento.upload      = "0Kbps"
    end

    if not form[:download].eql? ""
      equipamento.download     = form[:download]
    else
      equipamento.download      = "0Kbps"
    end

    if not form[:taxa_utilizacao].eql? ""
      equipamento.taxa_utilizacao_banda = form[:taxa_utilizacao]
    else
      equipamento.taxa_utilizacao_banda = "0"
    end

    if not form[:porcentagem_utilizacao].eql? ""
      equipamento.porcentagem_utilizacao_banda = form[:porcentagem_utilizacao]
    else
      equipamento.porcentagem_utilizacao_banda = "0"
    end


    equipamento.monitorar             = form[:monitorar]

    equipamento.updated_at           = Time.now
    equipamento.usuario_alteracao_id = @online.id

    equipamento.save!

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
    flash[:notice] = "Alerta do Equipamento Cadastrado Com Sucesso!"
    redirect_to :controller => '/equipamento', :action => 'visualizar'
  end

  def index
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def cadastro
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end  

  def cadastro_do
    form                        = params[:form]
    equipamento                 = Equipamento.new
    equipamentos                = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)
    equipamentos_monitorados    = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)


    equipamento.ip                   = form[:ip]
    equipamento.mascara_rede         = form[:mascara_rede]
    equipamento.mac_address          = form[:mac_address]
    equipamento.tipo                 = form[:tipo]
    equipamento.data_garantia        = Date.civil(*params[:data_garantia].sort.map(&:last).map(&:to_i))
    equipamento.marca                = form[:marca]
    equipamento.modelo               = form[:modelo]
    equipamento.versao               = form[:versao]
    equipamento.local_backup         = form[:local_backup]
    equipamento.numero_serie         = form[:numero_serie]
    equipamento.descricao            = form[:descricao]
    equipamento.observacao           = form[:observacao]
    equipamento.especificacao_tecnica = form[:especificacao_tecnica]
    equipamento.data_garantia        = form[:data_garantia]
    equipamento.cancelado            = form[:cancelado]
    equipamento.monitorar            = form[:monitorar]
    equipamento.updated_at           = Time.now
    equipamento.usuario_alteracao_id = @online.id

    equipamento.save!

      `rm -rf /home/carlos/tcc/app_network/script/alerta.txt`
      File.open('/home/carlos/tcc/app_network/script/alerta.txt', 'w') {|file| 
        equipamentos.each do |e|
          file.write("#{e.id} #{e.ip} #{e.uso_cpu_usuario} #{e.uso_cpu_sistema} #{e.swap_disponivel} #{e.ram_disponivel} #{e.disco_disponivel} #{e.upload} #{e.download}\n")
        end
      }

      `rm -rf /home/carlos/tcc/app_network/script/ip.txt`
      File.open('/home/carlos/tcc/app_network/script/ip.txt', 'w') {|file| 
        equipamentos_monitorados.each do |m|
          file.write("#{m.id} #{m.ip}\n")
        end
      }
 
    flash[:notice] = "Equipamento cadastrado Com Sucesso!"
    redirect_to :controller => '/equipamento', :action => 'cadastro'
  end

  def detalhes
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    if form[:equipamento_id].eql? ""
      flash[:notice] = "Selecione o equipamento"
      redirect_to :controller => '/equipamento', :action => 'visualizar'
    end
    @equipamento                = Equipamento.find_by_id form[:equipamento_id]
  end

  def editar
    
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    if form[:equipamento_id].eql? ""
      flash[:notice] = "Selecione o equipamento"
      redirect_to :controller => '/equipamento', :action => 'visualizar'
    end
    @equipamento                = Equipamento.find_by_id form[:equipamento_id]
  end

  def editar_do
    equipamentos                = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)
    equipamentos_monitorados    = Equipamento.where("cancelado = ? AND monitorar = ?", false, true)


    form                        = params[:form]
    equipamento                 = Equipamento.find_by_id form[:equipamento_id]

    equipamento.ip                   = form[:ip]
    equipamento.mac_address          = form[:mac_address]
    equipamento.tipo                 = form[:tipo]
    equipamento.data_garantia        = Date.civil(*params[:data_garantia].sort.map(&:last).map(&:to_i))
    equipamento.marca                = form[:marca]
    equipamento.modelo               = form[:modelo]
    equipamento.versao               = form[:versao]
    equipamento.data_backup          = form[:data_backup]
    equipamento.local_backup         = form[:local_backup]
    equipamento.numero_serie         = form[:numero_serie]
    equipamento.descricao            = form[:descricao]
    equipamento.observacao           = form[:observacao]
    equipamento.especificacao_tecnica = form[:especificacao_tecnica]
    equipamento.cancelado            = form[:cancelado]
    equipamento.monitorar            = form[:monitorar]
    equipamento.usuario_alteracao_id = @online.id

    equipamento.save!

      `rm -rf /home/carlos/tcc/app_network/script/alerta.txt`
      File.open('/home/carlos/tcc/app_network/script/alerta.txt', 'w') {|file| 
        equipamentos.each do |e|
          file.write("#{e.id} #{e.ip} #{e.uso_cpu_usuario} #{e.uso_cpu_sistema} #{e.swap_disponivel} #{e.ram_disponivel} #{e.disco_disponivel} #{e.upload} #{e.download}\n")
        end
      }

      `rm -rf /home/carlos/tcc/app_network/script/ip.txt`
      File.open('/home/carlos/tcc/app_network/script/ip.txt', 'w') {|file| 
        equipamentos_monitorados.each do |m|
          file.write("#{m.id} #{m.ip}\n")
        end
      }


    flash[:notice] = "Equipamento alterado Com Sucesso!"
    redirect_to :controller => '/equipamento', :action => 'visualizar'

  end

  def visualizar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @equipamentos                  = Equipamento.order("created_at DESC")
  end

end	
