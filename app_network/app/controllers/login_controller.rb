class LoginController < ApplicationController
  require 'digest/md5'

  def index
  end

  def index_do
    form     = params[:form]
    senha    = Digest::MD5.hexdigest("#{form[:senha]}") 
    usuario = Usuario.find_by_login_and_senha(form[:login], senha)
    if not usuario.nil? and usuario.arquivado.eql? false
        session[:usuario_id] = usuario.id
        redirect_to :controller => '/home', :action => 'index'
    else
      if usuario.nil?
        flash[:error] = "Usuario Não cadastrado"
      else
        flash[:error] = "Usuario Não tem Acesso"
      end
      redirect_to :controller => '/login', :action => 'index'
    end
  end
end
