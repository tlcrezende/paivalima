class CreateContratos < ActiveRecord::Migration[7.0]
  def change
    create_table :contratos do |t|
      t.references :lote, null: false, foreign_key: true
      t.references :cliente, null: false, foreign_key: true
      t.datetime :data_inicio
      t.integer :qnt_parcelas

      t.timestamps
    end
  end
end
