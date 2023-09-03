# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_02_175023) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_graphql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "pgjwt"
  enable_extension "pgsodium"
  enable_extension "plpgsql"
  enable_extension "supabase_vault"
  enable_extension "uuid-ossp"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "aal_level", ["aal1", "aal2", "aal3"]
  create_enum "code_challenge_method", ["s256", "plain"]
  create_enum "factor_status", ["unverified", "verified"]
  create_enum "factor_type", ["totp", "webauthn"]
  create_enum "key_status", ["default", "valid", "invalid", "expired"]
  create_enum "key_type", ["aead-ietf", "aead-det", "hmacsha512", "hmacsha256", "auth", "shorthash", "generichash", "kdf", "secretbox", "secretstream", "stream_xchacha20"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clientes", force: :cascade do |t|
    t.string "nome"
    t.string "cpf_cnpj"
    t.string "data_nascimento"
    t.string "celular"
    t.string "logradouro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cep"
    t.string "rg"
    t.string "cidade"
    t.string "uf"
  end

  create_table "contratos", force: :cascade do |t|
    t.bigint "lote_id", null: false
    t.bigint "cliente_id", null: false
    t.datetime "data_inicio"
    t.integer "qnt_parcelas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "valor"
    t.string "hennering_code"
    t.index ["cliente_id"], name: "index_contratos_on_cliente_id"
    t.index ["lote_id"], name: "index_contratos_on_lote_id"
  end

  create_table "importacoes", force: :cascade do |t|
    t.string "nome"
    t.string "seu_numero"
    t.string "nosso_numero"
    t.float "valor"
    t.float "valor_pago"
    t.datetime "data_vencimento"
    t.string "situacao"
    t.datetime "data_referencia"
    t.bigint "user_id", null: false
    t.bigint "planilha_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pagamento_alterado"
    t.index ["planilha_id"], name: "index_importacoes_on_planilha_id"
    t.index ["user_id"], name: "index_importacoes_on_user_id"
  end

  create_table "loteamentos", force: :cascade do |t|
    t.string "nome"
    t.string "registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lotes", force: :cascade do |t|
    t.bigint "loteamento_id", null: false
    t.integer "numero"
    t.float "tamanho"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loteamento_id"], name: "index_lotes_on_loteamento_id"
  end

  create_table "pagamentos", force: :cascade do |t|
    t.bigint "contrato_id", null: false
    t.bigint "cliente_id", null: false
    t.bigint "lote_id", null: false
    t.datetime "data_vencimento"
    t.float "valor"
    t.string "identificador"
    t.datetime "data_pagamento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ordem"
    t.integer "ordem_carne"
    t.string "carne_codigo"
    t.boolean "soft_deleted", default: false
    t.integer "planilha"
    t.integer "status", default: 0
    t.integer "tipo_pagamento"
    t.float "valor_pago"
    t.index ["cliente_id"], name: "index_pagamentos_on_cliente_id"
    t.index ["contrato_id"], name: "index_pagamentos_on_contrato_id"
    t.index ["lote_id"], name: "index_pagamentos_on_lote_id"
  end

  create_table "planilhas", force: :cascade do |t|
    t.datetime "data_referencia"
    t.integer "tipo"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_planilhas_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "username"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contratos", "clientes"
  add_foreign_key "contratos", "lotes"
  add_foreign_key "importacoes", "planilhas"
  add_foreign_key "importacoes", "users"
  add_foreign_key "lotes", "loteamentos"
  add_foreign_key "pagamentos", "clientes"
  add_foreign_key "pagamentos", "contratos"
  add_foreign_key "pagamentos", "lotes"
  add_foreign_key "planilhas", "users"
end
