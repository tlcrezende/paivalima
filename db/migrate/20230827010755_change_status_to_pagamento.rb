class ChangeStatusToPagamento < ActiveRecord::Migration[7.0]
  def change
    remove_column :pagamentos, :status
  end
end
