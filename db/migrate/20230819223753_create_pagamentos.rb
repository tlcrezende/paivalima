class CreatePagamentos < ActiveRecord::Migration[7.0]
  def change
    create_table :pagamentos do |t|
      t.references :contrato, null: false, foreign_key: true
      t.references :cliente, null: false, foreign_key: true
      t.references :lote, null: false, foreign_key: true
      t.datetime :data_vencimento
      t.float :valor
      t.string :status
      t.string :identificador
      t.datetime :data_pagamento

      t.timestamps
    end
  end
end
