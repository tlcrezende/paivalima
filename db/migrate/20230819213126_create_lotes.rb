class CreateLotes < ActiveRecord::Migration[7.0]
  def change
    create_table :lotes do |t|
      t.references :loteamento, null: false, foreign_key: true
      t.integer :numero
      t.float :valor
      t.integer :tamanho

      t.timestamps
    end
  end
end
