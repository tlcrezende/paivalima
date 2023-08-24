class CreateImportacoes < ActiveRecord::Migration[7.0]
  def change
    create_table :importacoes do |t|
      t.string :nome
      t.string :seu_numero
      t.string :nosso_numero
      t.float :valor
      t.float :valor_pago
      t.datetime :data_vencimento
      t.string :situacao
      t.datetime :data_referencia
      t.references :user, null: false, foreign_key: true
      t.references :planilha, null: false, foreign_key: true

      t.timestamps
    end
  end
end
