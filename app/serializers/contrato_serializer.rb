class ContratoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :qnt_parcelas, :qtde_parcelas_pagas
  has_one :lote
  has_one :cliente

  def qtde_parcelas_pagas
    object.pagamentos.filter(&:data_pagamento).size
  end
end
