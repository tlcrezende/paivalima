class AddHenneringCodeToContrato < ActiveRecord::Migration[7.0]
  def change
    add_column :contratos, :hennering_code, :string
  end
end
