class CreatePlanilhas < ActiveRecord::Migration[7.0]
  def change
    create_table :planilhas do |t|
      t.datetime :data
      t.integer :tipo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
