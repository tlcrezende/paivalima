class PagamentoLogic 

  def initialize(contrato_id, valor, qtde_parcelas, data_vencimento)
    @contrato_id = contrato_id
    @valor = valor
    @qtde_parcelas = qtde_parcelas
    @data_vencimento = data_vencimento
    @carne_codigo = ""
  end

  def validacao_carne
    # pagamentos = Pagamento.where(contrato_id: @contrato_id).pluck(:data_vencimento)
    # if pagamentos.any? {|d| d > @data_vencimento.to_datetime}
    #   raise "Pagamento futuro em outro carne já cadastrado"
    # end
  end

  def create_carne
    validacao_carne
    pagamentos = []
    ordem_carne = ordem_carne(carne_codigo)
    contrato = Contrato.find(@contrato_id)
    @qtde_parcelas.times do |i|
      parcela = (i + 1).to_s.rjust(3, '0')
      pagamentos << {
        contrato_id: @contrato_id,
        cliente_id: contrato.cliente_id,
        lote_id: contrato.lote_id,
        carne_codigo: carne_codigo,
        ordem_carne: ordem_carne + i,
        ordem: i+1, 
        valor: @valor, 
        data_vencimento: @data_vencimento.to_datetime.next_month(i),
        identificador: "#{carne_codigo}/#{parcela}",
        tipo_pagamento: :caixa_boleto,
        status: :pendente
      }
    end
    Pagamento.insert_all!(pagamentos)
  end

  def carne_codigo
    letra_separadora = 'A'
    codigos_existentes = Pagamento.pluck(:carne_codigo).uniq
    possivel_carne_codigo = "#{@contrato_id}#{letra_separadora}".rjust(5, '0')
    while letra_separadora <= 'ZZ'
      break unless codigos_existentes.include?(possivel_carne_codigo)
      possivel_carne_codigo.next!
    end
    @carne_codigo = possivel_carne_codigo
  end

  def ordem_carne(carne_codigo)
    letra_carne_codigo_novo = carne_codigo.last
    letra_carne_codigo_antigo = (letra_carne_codigo_novo.ord - 1).chr
    carne_codigo_antigo = carne_codigo[0..3] + letra_carne_codigo_antigo
    ordem_carne = Pagamento.where(carne_codigo: carne_codigo_antigo).first&.ordem_carne
    return 1 if ordem_carne.nil?
    return ordem_carne + 1
  end

  def codigo
    @carne_codigo
  end
end