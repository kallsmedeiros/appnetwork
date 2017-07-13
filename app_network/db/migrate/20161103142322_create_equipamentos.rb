class CreateEquipamentos < ActiveRecord::Migration[5.0]
  def change
    create_table :equipamentos do |t|
      t.string    :ip
      t.string    :mascara_rede
      t.string    :mac_address
      t.string    :tipo
      t.date      :data_garantia
      t.string    :marca
      t.string    :modelo
      t.string    :versao
      t.datetime  :data_backup
      t.string    :local_backup
      t.string    :numero_serie
      t.string    :descricao
      t.string    :observacao
      t.string    :especificacao_tecnica
      t.boolean   :cancelado
      t.integer   :usuario_alteracao_id
      t.timestamps
    end
  end
end
