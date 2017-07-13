class Alertum < ApplicationRecord
#Relacionamentos
  belongs_to :equipamento

  belongs_to :monitoramento
end
