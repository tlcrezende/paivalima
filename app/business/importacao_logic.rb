require 'roo'

class ImportacaoLogic 

  def initialize(file, user_id, data_referencia)
    @file = file
    @user_id = user_id
    @data_referencia = data_referencia
    @parsed = false
    @saved = false
    @pagamentos_existentes_validados = false
    @pagamentos = []
  end

  def importar_dados
    @tmpfile = Tempfile.new.binmode
    @tmpfile << Base64.decode64(@file)
    @tmpfile.rewind
    # parse_file if !data_existente?
    parse_file
    save_planilha if @parsed
    save_data if @saved
    validar_pagamentos_existente
  end

  def saved?
    @saved
  end
  
  def planilha_id 
    @planilha.id
  end

  def data_existente?
    Planilha.where(data: @data_referencia).any?
  end

  def validar_pagamentos_existente 
    pagamentos_nao_existentes = @pagamentos.pluck('seu_número') - Pagamento.pluck(:identificador)
    byebug
    if pagamentos_nao_existentes.empty?
      @pagamentos_existentes_validados = true
    else
      raise "Alguns pagamentos não existem no sistema: #{pagamentos_nao_existentes}"
    end
  end

  def parse_file
    xlsx = Roo::Spreadsheet.open(@tmpfile.path, extension: :xlsx)

    # Definir função de validação da sheet
    # 1 - Verificar headerRow - Deve ser idêntica
    # 2 - Filtrar resultados com valor pago
    # 3 - Parse nas tipagens para garantir consistência no banco

    headers = ['Nome', 'Seu Número', 'Nosso Numero', 'Valor', 'Valor Pago', 'Vencimento', 'Situação']
    snake_case_headers = headers.map { |el| el.sub(' ', '') }.map(&:underscore)

    xlsx.sheets.each do |sheet_name|
      sheet = xlsx.sheet(sheet_name)
      sheet.each_row_streaming(offset: 2).with_index do |row, index_row|
        pagamento = { id: index_row + 1 }
        
        row.each_with_index do |cell, index_col|
          pagamento[snake_case_headers[index_col]] = cell.value
          raise "#{sheet_name} coluna com célula vazia: #{snake_case_headers[index_col]}" if cell.value.nil? && pagamento[snake_case_headers[0]] != 'Totais::::>'
        end
        
        next if pagamento['nome'].include? 'Totais::::>'

        next unless pagamento['valor_pago'].positive?


        @pagamentos << pagamento
      end
    end

    @parsed = true
  end

  def save_planilha
    @planilha = Planilha.create!(tipo: :importacao_caixa, data: Time.zone.now, user_id: @user_id)
    @planilha.arquivo.attach(io: File.open(@tmpfile.path), filename: "Planilha Caixa - #{Time.zone.now}.xlsx")
    @saved = true
  end

  def save_data 
    importacao = []
    @pagamentos.each do |pagamento|
      importacao << {
        planilha_id: @planilha.id, 
        user_id: @user_id, 
        nome: pagamento['nome'], 
        seu_numero: pagamento['seu_número'], 
        nosso_numero: pagamento['nosso_numero'],
        valor: pagamento['valor'], 
        valor_pago: pagamento['valor_pago'], 
        data_vencimento: pagamento['vencimento'], 
        situacao: pagamento['situação'], 
        data_referencia: @data_referencia
      }
    end
    ActiveRecord::Base.transaction { Importacao.insert_all!(importacao) }
  end

end