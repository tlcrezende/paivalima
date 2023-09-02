class AddPagamentoAlteradoToPagamento < ActiveRecord::Migration[7.0]
  def change
    add_column :importacoes, :pagamento_alterado, :boolean
  end
end
