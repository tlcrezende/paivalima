class LoteSerializer < ActiveModel::Serializer
  attributes :id, :numero, :valor, :tamanho, :qtde_pagamentos_recebidos, :qtde_pagamentos, :valor_recebido, :contratos

  has_one :loteamento

  def contratos
    # Condição de vigencia do contrato: quitado ou com algum pagamento futuro.
    object.contratos.map do |contrato|
      {
        **contrato.attributes.symbolize_keys,
        qtde_parcelas_pagas: contrato.pagamentos.filter(&:data_pagamento).size,
        valor_arrecadado: contrato.pagamentos.filter(&:data_pagamento).sum(&:valor) || 0,
        cliente: contrato.cliente,
        vigente: contrato.pagamentos.filter(&:data_pagamento).size == contrato.pagamentos.size ||
          contrato.pagamentos.filter { |p| p.data_vencimento > Time.zone.now }.size.positive?
      }
    end
  end

  def qtde_pagamentos_recebidos
    object.pagamentos.filter(&:data_pagamento).size
  end

  def qtde_pagamentos
    object.pagamentos.size
  end

  def valor_recebido
    object.pagamentos.filter(&:data_pagamento).sum(&:valor)
  end
end
