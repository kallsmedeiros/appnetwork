class Configuracao < ApplicationRecord
  belongs_to :usuario,
  :class_name => 'Usuario',
  :foreign_key => 'usuario_id'

end

