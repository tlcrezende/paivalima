class PagamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_vencimento, :valor, :status, :identificador, :data_pagamento
  has_one :contrato
  has_one :cliente
  has_one :lote
end
