class ChangeNameOnPlanilha < ActiveRecord::Migration[7.0]
  def change
    rename_column :planilhas, :data, :data_referencia
  end
end
