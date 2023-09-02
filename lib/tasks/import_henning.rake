require 'csv'

namespace :import do
  task :henning => :environment do
    file_path = 'files/PAGAMENTOS_LOTEAMENTO_CHAC_MARRUA.xlsx'

    xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)

    dados = []
    contratos_nao_encontrados = []

    xlsx.sheets.each do |sheet_name|
      numero = sheet_name.last.to_i
      if numero.even?
        sheet = xlsx.sheet(sheet_name)
        sheet.each_row_streaming(offset: 0).with_index do |row, index_row|
          dados << {
            hennering_code: row[1].value.split('/')[0],
            created_at: row[2].value,
            data_vencimento: row[3].value,
            data_pagamento: row[4].value,
            valor_a_receber: row[5].value,
            valor_recebido: row[6].value,
          }
        end
      end

      break if dados.count == 100
    end

    # id_pagamento = Pagamento.last?.id
    id_pagamento = 1

    dados.each do |d| 
      if Contrato.find_by(hennering_code: d[:hennering_code]).nil? 
        p "Contrato #{d[:hennering_code]} não encontrado"
        contratos_nao_encontrados << d[:hennering_code]
      else
        p "Contrato #{d[:hennering_code]} encontrado"
        contrato = Contrato.find_by(hennering_code: d[:hennering_code])
        pagamento = Pagamento.new
        pagamento.data_vencimento = d[:data_vencimento]
        pagamento.data_pagamento = d[:data_pagamento]
        pagamento.valor_pago = d[:valor_recebido]
        pagamento.contrato_id = contrato.id
        pagamento.cliente_id = contrato.cliente_id
        pagamento.lote_id = contrato.lote_id
        pagamento.status = d[:data_pagamento].nil? ? 0 : 1
        pagamento.identificador = id_pagamento
        pagamento.tipo_pagamento = 0
        pagamento.save
        p "Pagamento #{pagamento.id} criado"
        id_pagamento += 1
      end
    end
  end
end
