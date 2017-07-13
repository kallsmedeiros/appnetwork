class CreateUsuarios < ActiveRecord::Migration[5.0]
  def change
    create_table :usuarios do |t|
      t.string    :nome
      t.string    :nome_completo
      t.date      :data_nascimento
      t.string    :estado
      t.string    :municipio
      t.string    :logradouro
      t.string    :numero
      t.string    :complemento
      t.string    :cpf
      t.string    :senha
      t.string    :login
      t.boolean   :arquivado
      t.integer   :projeto_id
      t.string    :celular
      t.string    :email
      t.string    :sexo
      t.integer   :usuario_alteracao_id
      t.boolean   :receber_email
      t.timestamps
    end
  end
end
