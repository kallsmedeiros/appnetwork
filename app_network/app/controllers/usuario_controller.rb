class UsuarioController < ApplicationController
  require 'digest/md5'

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
    @usuarios                   = Usuario.where("arquivado = false").order("created_at DESC")
    form                        = params[:form]
    usuario                     = Usuario.new

    usuario.nome                = form[:nome]
    usuario.nome_completo       = form[:nome_completo]
    usuario.data_nascimento     = Date.civil(*params[:data_nascimento].sort.map(&:last).map(&:to_i))
    usuario.cpf                 = form[:cpf]
    usuario.email               = form[:email]
    usuario.celular             = form[:celular]
    usuario.login               = form[:login]
    usuario.senha               = Digest::MD5.hexdigest("#{form[:senha]}")
    usuario.sexo                = form[:sexo]
    if form[:receber_email].eql? "true"
      usuario.receber_email       = true
    else
      usuario.receber_email       = false
    end
    usuario.arquivado             = true

# ENDERECO
    usuario.estado              = form[:estado]
    usuario.municipio           = form[:municipio]
    usuario.logradouro          = form[:logradouro]
    usuario.numero              = form[:numero]
    usuario.complemento         = form[:complemento]

    usuario.save!

#atualizando arquivo de emails

    File.open('/home/carlos/tcc/app_network/script/email.txt', 'w') {|file|
      @usuarios.each do |u|
        if not u.email.eql? "" and u.receber_email.eql? true
          file.write("#{u.email}\n")
        end
      end
    }


    flash[:notice] = "Usuario cadastrado Com Sucesso!"
    redirect_to :controller => '/usuario', :action => 'cadastro'
  end

  def detalhes
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    @usuario                    = Usuario.find_by_id form[:usuario_id]
  end

  def editar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    form                        = params[:form]
    @usuario                    = Usuario.find_by_id form[:usuario_id]
  end

  def editar_do
    @usuarios        = Usuario.where("arquivado = ?", false)
    form                        = params[:form]
    usuario                     = Usuario.find_by_id form[:usuario_id]

    usuario.nome                = form[:nome]
    usuario.nome_completo       = form[:nome_completo]
    usuario.data_nascimento     = Date.civil(*params[:data_nascimento].sort.map(&:last).map(&:to_i))
    usuario.cpf                 = form[:cpf]
    usuario.email               = form[:email]
    usuario.celular             = form[:celular]
    usuario.login               = form[:login]
    usuario.senha               = Digest::MD5.hexdigest("#{form[:senha]}")
    usuario.sexo                = form[:sexo]
    if form[:receber_email].eql? "true"
      usuario.receber_email       = true
    else
      usuario.receber_email       = false
    end
    usuario.arquivado           = form[:arquivado]
    usuario.usuario_alteracao_id = @online.id

# ENDERECO
    usuario.estado              =form[:estado]
    usuario.municipio           =form[:municipio]
    usuario.logradouro          =form[:logradouro]
    usuario.numero              =form[:numero]
    usuario.complemento         =form[:complemento]

    usuario.save!

#atualizando arquivo de emails
    `rm -rf /home/carlos/tcc/app_network/script/email.txt`
      File.open('/home/carlos/tcc/app_network/script/email.txt', 'w') {|file|
        @usuarios.each do |u|
         if not u.email.eql? "" and u.receber_email.eql? true
            file.write("#{u.email}\n")
          end
        end
      }

    flash[:notice] = "Usuario alterado Com Sucesso!"
    redirect_to :controller => '/usuario', :action => 'visualizar'

  end

  def visualizar
    if @online.eql? nil
      redirect_to :controller => '/login', :action => 'index'
    end
    @usuarios                   = Usuario.order("created_at DESC")
  end

end
