class AddSoftDeletedToPagamento < ActiveRecord::Migration[7.0]
  def change
    add_column :pagamentos, :soft_deleted, :boolean, default: false
  end
end
