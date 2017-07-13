class CreateMonitoramentos < ActiveRecord::Migration[5.0]
  def change
    create_table :monitoramentos do |t|
      t.string    :ip
      t.string    :uso_cpu_usuario
      t.string    :tempo_absoluto_cpu_usuario
      t.string    :uso_cpu_sistema
      t.string    :tempo_absoluto_cpu_sistema
      t.string    :porcentagem_cpu_ociosa
      t.string    :tempo_cpu_ociosa
      t.string    :tamanho_swap
      t.string    :swap_disponivel
      t.string    :tamanho_ram
      t.string    :ram_utilizada
      t.string    :ram_disponivel
      t.string    :tamanho_cache
      t.string    :tamanho_disco
      t.string    :disco_disponivel
      t.string    :disco_utilizado
      t.string    :sistema_iniciado
      t.integer   :equipamento_id
      t.string    :upload
      t.string    :download
      t.string    :taxa_utilizacao_banda
      t.string    :porcentagem_utilizacao_banda
      t.datetime  :hora_registro
    end
  end
end
