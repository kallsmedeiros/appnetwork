class CreateConfiguracaos < ActiveRecord::Migration[5.0]
  def change
    create_table :configuracaos do |t|
      t.string   :tema
      t.string   :menu
      t.integer  :usuario_id
      t.timestamps
    end
  end
end
