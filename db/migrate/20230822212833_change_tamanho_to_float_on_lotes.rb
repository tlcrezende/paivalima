class ChangeTamanhoToFloatOnLotes < ActiveRecord::Migration[7.0]
  def change
    change_column :lotes, :tamanho, :float
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
