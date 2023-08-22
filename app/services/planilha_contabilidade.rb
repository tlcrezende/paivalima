require 'csv'

class PlanilhaContabilidade
  def self.gerar(data_inicio, data_fim)
    file = Tempfile.new('planilha_contabilidade.csv')
    # file = "#{Rails.root}/tmp/planilha_contabilidade.csv"
    pagamentos = Pagamento.includes(:contrato, :cliente, :lote)
                          .where('data_pagamento >= ? AND data_pagamento <= ?', data_inicio, data_fim)
    headers = ['Data Pagamento', 'Valor', 'Cliente', 'Lote', 'Contrato']

    CSV.open(file, 'wb', write_headers: true, headers: headers, col_sep: ',') do |writer|
      pagamentos.each do |pagamento|
        writer << [pagamento.data_pagamento, pagamento.valor, pagamento.cliente.nome, pagamento.lote.numero, pagamento.contrato_id]
      end
    end

    planilha = Planilha.create!(tipo: :exportacao_contabilidade, data: Time.zone.now, user_id: 1)
    planilha.arquivo.attach(io: File.open(file), filename: 'planilha_contabilidade.csv')

    planilha.arquivo.blob.url
  end
end
