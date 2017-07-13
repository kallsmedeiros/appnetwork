class CreateAlerta < ActiveRecord::Migration[5.0]
  def change
    create_table :alerta do |t|
      t.string    :descricao
      t.string    :ip      
      t.integer   :equipamento_id
      t.integer   :monitoramento_id
      t.timestamps
    end
  end
end
