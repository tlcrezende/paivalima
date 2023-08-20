class LoteSerializer < ActiveModel::Serializer
  attributes :id, :numero, :valor, :tamanho, :loteamento_nome, :qtde_pagamentos_recebidos, :qtde_pagamentos, :valor_recebido, :contratos

  def loteamento_nome
    object.loteamento.nome
  end

  def contratos
    return nil unless instance_options[:show_contratos].present?

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
    return nil unless instance_options[:show_contratos].present?

    object.pagamentos.filter(&:data_pagamento).size
  end

  def qtde_pagamentos
    return nil unless instance_options[:show_contratos].present?

    object.pagamentos.size
  end

  def valor_recebido
    return nil unless instance_options[:show_contratos].present?

    object.pagamentos.filter(&:data_pagamento).sum(&:valor)
  end
end
