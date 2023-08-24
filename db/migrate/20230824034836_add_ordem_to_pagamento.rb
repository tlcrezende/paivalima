class AddOrdemToPagamento < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :ordem, :integer
  end
end
