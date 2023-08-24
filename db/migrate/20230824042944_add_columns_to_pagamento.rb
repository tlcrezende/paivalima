class AddColumnsToPagamento < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :ordem_carne, :integer
    add_column :pagamentos, :carne_codigo, :string
  end
end
