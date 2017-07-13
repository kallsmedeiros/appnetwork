class Usuario < ApplicationRecord
#relacionamentos
has_one :configuracao

#validacoes
   self.table_name = 'usuarios'
    validates_presence_of :nome, :nome_completo,:cpf, :senha, :login
    validates_uniqueness_of :cpf, :email, :login

#metodos
  def to_s
    self.nome
  end
end
