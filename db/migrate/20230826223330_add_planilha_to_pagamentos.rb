class AddPlanilhaToPagamentos < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :planilha, :integer
  end
end
