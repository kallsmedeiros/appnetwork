class ApplicationController < ActionController::Base
   before_filter :load_user
   protect_from_forgery with: :exception
  def index
  end

  def load_user
    if session[:usuario_id]
      @online = Usuario.find(session[:usuario_id])
      unless @online.configuracao.eql? nil
        @config = @online.configuracao
      end
    end
  end

  def logout
    reset_session
#apagar usuario do BD
#    @online.try(:destroy)
    redirect_to :controller => '/home', :action => 'index'
  end
end
