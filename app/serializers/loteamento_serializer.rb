class LoteamentoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :registro, :tamanho, :lotes, :qtde_lotes, :qtde_lotes_com_contrato, :valor, :valor_arrecadado
  def lotes
    return nil unless instance_options[:show_lotes]

    pagamentos_recebidos = qtde_pagamentos_recebidos
    pagamentos = qtde_pagamentos
    valores = valor_recebido
    arr = []
    object.lotes.each_with_index do |lote, index|
      arr << {
        **lote.attributes.symbolize_keys,
        qtde_pagamentos_recebidos: pagamentos_recebidos[index],
        qtde_pagamentos: pagamentos[index],
        valor_recebido: valores[index]
      }
    end
    arr
  end

  # TODO: otimizar query depois para não disparar n+1
  def qtde_lotes
    object.lotes.size
  end

  def qtde_lotes_com_contrato
    object.contratos.size
  end

  def valor
    object.lotes.sum(:valor)
  end

  def valor_arrecadado
    object.lotes.includes(contratos: :pagamentos).map(&:contratos).flatten
          .map(&:pagamentos).flatten.filter(&:data_pagamento).sum(&:valor)
  end

  def qtde_pagamentos_recebidos
    object.lotes.includes(:pagamentos).map(&:pagamentos).map { |p| p.filter(&:data_pagamento).size }
  end

  def qtde_pagamentos
    object.lotes.includes(:pagamentos).map(&:pagamentos).map(&:size)
  end

  def valor_recebido
    object.lotes.includes(:pagamentos).map(&:pagamentos).map { |p| p.filter(&:data_pagamento).sum(&:valor) }
  end
end
