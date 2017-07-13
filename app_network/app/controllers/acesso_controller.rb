class AcessoController < ApplicationController
  def index
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
  end

  def cadastro
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

  def cadastro_do
    form                        = params[:form]
    acesso                      = Acesso.new

    acesso.equipamento_id       = form[:equipamento_id]
    acesso.login                = form[:login]
    acesso.senha                = form[:senha]
    acesso.usuario_alteracao_id = @online.id

    acesso.save!
    flash[:notice] = "Login cadastrado Com Sucesso!"
    redirect_to :controller => '/equipamento', :action => 'visualizar'
  end

  def editar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
#    if not @online.nivel.eql? 1
#      flash[:error] = "Acesso Negado!"
#      redirect_to :controller => '/home', :action => 'index'
#    end
    form                        = params[:form]
    if form[:acesso_id].eql? ""
      flash[:notice] = "Selecione o login"
      redirect_to :controller => '/equipamento', :action => 'visualizar'
    end
    @acesso                     = Acesso.find_by_id form[:acesso_id]
  end

  def editar_do
    form                        = params[:form]
    acesso                      = Acesso.find_by_id form[:acesso_id]

    acesso.equipamento_id       = form[:equipamento_id]
    acesso.login                = form[:login]
    acesso.senha                = form[:senha]
    acesso.usuario_alteracao_id = @online.id

    acesso.save!
    flash[:notice] = "Login Alterado Com Sucesso!"
    redirect_to :controller => '/equipamento', :action => 'visualizar'
  end
  def excluir
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    if form[:acesso_id].eql? ""
      flash[:notice] = "Selecione o login"
      redirect_to :controller => '/equipamento', :action => 'visualizar'
    end
    acesso                     = Acesso.find_by_id form[:acesso_id]
    acesso.try(:destroy)
    flash[:notice] = "Login Excluido com Sucesso"
    redirect_to :controller => '/equipamento', :action => 'visualizar' 
  end

  def visualizar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @acessos                  = Acesso.order("created_at DESC")
  end
end
