class Equipamento < ApplicationRecord
#relacionamento

  has_many :acesso
  
  has_many :monitoramentos,
  :class_name => 'Monitoramento'

  
  has_many :alertas,
  :class_name => 'Alertum'

  belongs_to :usuario_alteracao,
  :class_name => 'Usuario',
  :foreign_key => 'usuario_alteracao_id'

#validacoes
  def validate?
    validates_presence_of :ip, :uso_cpu_usuario, :uso_cpu_sistema, :ram_disponivel, :swap_disponivel, :disco_disponivel
  end

end
