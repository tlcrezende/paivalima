class AddObservacaoToPagamento < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :observacao, :string
  end
end
