class LoteSerializer < ActiveModel::Serializer
  attributes :id, :numero, :valor, :tamanho
  has_one :loteamento
end
