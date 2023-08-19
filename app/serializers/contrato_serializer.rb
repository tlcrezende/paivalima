class ContratoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :datetime, :qnt_parcelas, :integer
  has_one :lote
  has_one :cliente
end
