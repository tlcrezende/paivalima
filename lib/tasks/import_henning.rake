require 'csv'

namespace :import do
  task :henning => :environment do
    # file_path = 'files/PAGAMENTOS_LOTEAMENTO_CHAC_MARRUA.xlsx'

    # xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)

    # dados = []
    # contratos_nao_encontrados = []

    # xlsx.sheets.each do |sheet_name|
    #   numero = sheet_name.last.to_i
    #   if numero.even?
    #     sheet = xlsx.sheet(sheet_name)
    #     sheet.each_row_streaming(offset: 0).with_index do |row, index_row|
    #       dados << {
    #         hennering_code: row[1].value.split('/')[0],
    #         created_at: row[2].value,
    #         data_vencimento: row[3].value,
    #         data_pagamento: row[4].value,
    #         valor_a_receber: row[5].value,
    #         valor_recebido: row[6].value,
    #       }
    #     end
    #   end

    #   break if dados.count == 100
    # end

    # if Pagamento.all.empty?
    #   id_pagamento = 1 
    # else
    #   id_pagamento = Pagamento.last.id + 1
    # end
    data_path  = 'files/pagamentos.json'
    data_json = File.open(data_path).read
    data = JSON.parse(data_json, symbolize_names: true)

    data.each_with_index do |d, index| 
      p "Pagamento #{index} de #{data.count}"
      if Contrato.find_by(hennering_code: d[:cliente_codigo_henning].to_s).nil? 
        p "Contrato #{d[:cliente_codigo_henning].to_s} não encontrado..."
        # contratos_nao_encontrados << d[:hennering_code] unless contratos_nao_encontrados.include?(d[:hennering_code])
      else
        p "Contrato #{d[:cliente_codigo_henning].to_s} encontrado..."
        contrato = Contrato.find_by(hennering_code: d[:cliente_codigo_henning].to_s)
        pagamento = Pagamento.new
        pagamento.data_vencimento = DateTime.parse(d[:data_vencimento])
        pagamento.data_pagamento = DateTime.parse(d[:data_pagamento]) if d[:data_pagamento].present?
        pagamento.valor_pago = d[:valor_pago]
        pagamento.valor = d[:valor_nominal]
        pagamento.contrato_id = contrato.id
        pagamento.cliente_id = contrato.cliente_id
        pagamento.lote_id = contrato.lote_id
        pagamento.status = d[:data_pagamento] ? 1 : 0
        pagamento.identificador = d[:codigo_henning]
        pagamento.tipo_pagamento = 0
        pagamento.ordem_carne = d[:numero_parcela]
        pagamento.ordem = d[:ordem_geral_contrato]
        pagamento.carne_codigo = d[:ordem_carne]
        pagamento.observacao = d[:observacao]
        pagamento.planilha = 0
        pagamento.created_at = DateTime.parse(d[:data_emissao])
        if pagamento.save
          p "Pagamento #{pagamento.id} criado"
        end
      end
    end
  end
end
