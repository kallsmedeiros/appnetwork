class CreateAcessos < ActiveRecord::Migration[5.0]
  def change
    create_table :acessos do |t|
      t.string    :login
      t.string    :senha
      t.integer   :equipamento_id
      t.integer   :usuario_alteracao_id
      t.timestamps
    end
  end
end
