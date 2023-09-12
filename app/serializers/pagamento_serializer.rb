class PagamentoSerializer < ActiveModel::Serializer
  attributes :id, :data_vencimento, :valor, :status, :identificador, 
              :data_pagamento, :nome_cliente, :nome_loteamento, :lote, 
              :parcela, :data_pagamento, :ordem_carne, :carne, :tipo_pagamento

  def nome_cliente
    object.cliente.nome
  end

  def nome_loteamento
    object.lote.loteamento.nome
  end

  def lote 
    object.lote.numero.to_i
  end

  def parcela 
    object.ordem
  end
end