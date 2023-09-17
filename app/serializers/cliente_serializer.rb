class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :nome, :apelido, :cpf_cnpj, :rg, :data_nascimento, :logradouro, :cep, :cidade, :uf, :celular, :contratos, :pagamentos, :email

  def contratos
    object.contratos.map do |contrato|
      {
        id: contrato.id,
        loteamento_lote: "#{contrato.lote.loteamento.nome} - Lote #{contrato.lote.numero}",
        data_inicio: contrato.data_inicio,
        qtde_parcelas_pagas: contrato.pagamentos.where.not(data_pagamento: nil).size,
        qtde_parcelas: contrato.qnt_parcelas,
        valor: contrato.valor,
        valor_recebido: contrato.pagamentos.where.not(data_pagamento: nil).sum(:valor)
      }
    end
  end

  def pagamentos
    sorted_pagamentos = object.pagamentos.sort_by(&:data_vencimento).reverse

    sorted_pagamentos.map do |pagamento|
      {
        id: pagamento.id,
        data_vencimento: pagamento.data_vencimento,
        valor: pagamento.valor,
        valor_pago: pagamento.valor_pago,
        loteamento_lote: "#{pagamento.contrato.lote.loteamento.nome} / Lote #{pagamento.contrato.lote.numero}",
        ordem: pagamento.ordem,
        qtde_parcelas: pagamento.contrato.qnt_parcelas,
        status: pagamento.data_pagamento.present? ? 'Pago' : 'Pendente'
      }
    end
  end
end
