class MonitoramentoController < ApplicationController
  def index
    @arquivo = File.readlines('/home/carlos/tcc/app_network/arquivos/tabela_monitoramento.txt')
    if @arquivo.eql? []
      flash[:notice] = "Tabela de Monitoramento alterado Com Sucesso! Aguarde 1 minuto para acessar"
      redirect_to :controller => '/relatorio', :action => 'monitoramento_filtrar'
    end
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @monitoramento_ultimo              = Monitoramento.order("id DESC").limit 1
    @equipamentos                = Equipamento.where("cancelado = false").order("created_at")
    @alertas                     = Alertum.order("created_at DESC").limit 10
    tempo = Time.now - 15*60
    tempo = tempo.to_s.gsub('-0300','+0000')
    if @monitoramento_ultimo.last.hora_registro.to_time < tempo.to_time
      flash[:notice] = "Alerta O Ultimo Monitoramento Aconteceu a mais de 15 Minutos, Ultimo Monitoramento: #{@monitoramento_ultimo.last.hora_registro}"
    end

  end
  def editar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @equipamentos                = Equipamento.where("cancelado = false")
  end
  def tabela
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                         = params[:form]
    @coluna                      = form[:coluna]
    @linha                       = form[:linha]
    @equipamentos                = Equipamento.where("cancelado = false").order("created_at")
  end 
  def editar_do
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @equipamentos                = Equipamento.where("cancelado = false")
    `rm -rf /home/carlos/tcc/app_network/arquivos/tabela_monitoramento.txt`
    arquivo = File.new("/home/carlos/tcc/app_network/arquivos/tabela_monitoramento.txt", "w+") 
    form                         = params[:form]
    coluna                      = form[:coluna]
    linha                       = form[:linha]
    arquivo << "#{linha} #{coluna}"
    for i in 1..linha.to_i
      linha_arquivo = []
      for j in 1..coluna.to_i
        a = "L#{i}C#{j}"
        if params[a.to_sym].eql? ""
          linha_arquivo << "i"
        else
          linha_arquivo << params[a.to_sym]
        end
      end
      arquivo << linha_arquivo
    end
    flash[:notice] = "Tabela de Monitoramento alterado Com Sucesso! Aguarde 1 minuto para acessar"
    redirect_to :controller => '/relatorio', :action => 'monitoramento_filtrar'
  end
end
