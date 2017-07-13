class HomeController < ApplicationController
  def index
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    else
      redirect_to :controller => '/monitoramento', :action => 'index'
    end
  end
end
