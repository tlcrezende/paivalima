class PagamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_vencimento, :valor, :status, :identificador, :data_pagamento, :cliente_nome, :loteamento_nome, :lote_numero

  def cliente_nome
    object.cliente.nome
  end

  def loteamento_nome
    object.lote.loteamento.nome
  end

  def lote_numero 
    object.lote.numero.to_i
  end
end
