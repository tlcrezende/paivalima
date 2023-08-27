class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :nome, :cpf_cnpj, :data_nascimento, :celular, :endereco, :contratos, :pagamentos

  def contratos
    object.contratos.map do |contrato|
      {
        id: contrato.id,
        loteamento_lote: "#{contrato.lote.loteamento.nome} - Lote #{contrato.lote.numero}",
        data_inicio: contrato.data_inicio,
        qtde_parcelas_pagas: contrato.pagamentos.where.not(data_pagamento: nil).size,
        qtde_parcelas: contrato.qnt_parcelas,
        valor: contrato.lote.valor,
        valor_recebido: contrato.pagamentos.where.not(data_pagamento: nil).sum(:valor)
      }
    end
  end

  def pagamentos
    object.pagamentos.map do |pagamento|
      {
        id: pagamento.id,
        data_vencimento: pagamento.data_vencimento,
        valor: pagamento.valor,
        loteamento_lote: "#{pagamento.contrato.lote.loteamento.nome} / Lote #{pagamento.contrato.lote.numero}",
        ordem: pagamento.ordem,
        qtde_parcelas: pagamento.contrato.qnt_parcelas,
        status: pagamento.data_pagamento.present? ? 'Pago' : 'Pendente'
      }
    end
  end
end
