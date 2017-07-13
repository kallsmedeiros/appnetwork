# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161219143009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acessos", force: :cascade do |t|
    t.string   "login"
    t.string   "senha"
    t.integer  "equipamento_id"
    t.integer  "usuario_alteracao_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "alerta", force: :cascade do |t|
    t.string   "descricao"
    t.string   "ip"
    t.integer  "equipamento_id"
    t.integer  "monitoramento_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "configuracaos", force: :cascade do |t|
    t.string   "tema"
    t.string   "menu"
    t.integer  "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipamentos", force: :cascade do |t|
    t.string   "ip"
    t.string   "mascara_rede"
    t.string   "mac_address"
    t.string   "tipo"
    t.date     "data_garantia"
    t.string   "marca"
    t.string   "modelo"
    t.string   "versao"
    t.datetime "data_backup"
    t.string   "local_backup"
    t.string   "numero_serie"
    t.string   "descricao"
    t.string   "observacao"
    t.string   "especificacao_tecnica"
    t.boolean  "cancelado"
    t.integer  "usuario_alteracao_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "uso_cpu_usuario",              default: 100
    t.integer  "uso_cpu_sistema",              default: 100
    t.boolean  "monitorar",                    default: false,   null: false
    t.string   "swap_disponivel",              default: "0"
    t.string   "ram_disponivel",               default: "0"
    t.string   "disco_disponivel",             default: "0"
    t.string   "upload",                       default: "0Mbps"
    t.string   "download",                     default: "0Mbps"
    t.string   "taxa_utilizacao_banda",        default: "0Mbps"
    t.string   "porcentagem_utilizacao_banda", default: "0Mbps"
  end

  create_table "monitoramentos", force: :cascade do |t|
    t.string   "ip"
    t.string   "uso_cpu_usuario"
    t.string   "tempo_absoluto_cpu_usuario"
    t.string   "uso_cpu_sistema"
    t.string   "tempo_absoluto_cpu_sistema"
    t.string   "porcentagem_cpu_ociosa"
    t.string   "tempo_cpu_ociosa"
    t.string   "tamanho_swap"
    t.string   "swap_disponivel"
    t.string   "tamanho_ram"
    t.string   "ram_utilizada"
    t.string   "ram_disponivel"
    t.string   "tamanho_cache"
    t.string   "tamanho_disco"
    t.string   "disco_disponivel"
    t.string   "disco_utilizado"
    t.string   "sistema_iniciado"
    t.integer  "equipamento_id"
    t.string   "upload"
    t.string   "download"
    t.string   "taxa_utilizacao_banda"
    t.string   "porcentagem_utilizacao_banda"
    t.datetime "hora_registro"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "nome"
    t.string   "nome_completo"
    t.date     "data_nascimento"
    t.string   "estado"
    t.string   "municipio"
    t.string   "logradouro"
    t.string   "numero"
    t.string   "complemento"
    t.string   "cpf"
    t.string   "senha"
    t.string   "login"
    t.boolean  "arquivado"
    t.integer  "projeto_id"
    t.string   "celular"
    t.string   "email"
    t.string   "sexo"
    t.integer  "usuario_alteracao_id"
    t.boolean  "receber_email"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
