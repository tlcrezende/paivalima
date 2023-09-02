require 'roo'

class ImportacaoLogic 

  def initialize(file, user_id, data_referencia)
    @file = file
    @user_id = user_id
    @data_referencia = data_referencia
    @parsed = false
    @saved = false
    @pagamentos_modificados = false
    @pagamentos = []
  end

  def importar_dados
    @tmpfile = Tempfile.new.binmode
    @tmpfile << Base64.decode64(@file)
    @tmpfile.rewind
    # Verifica se já existe uma planilha com a data de referência
    validar_data_referencia
    # Extrai as informações da planilha
    parse_file
    # Verifica se todos os pagamentos existentes na planilha também existem no banco de dados
    # validar_pagamentos_existente
    # # Verifica se todos os status são pendentes
    validar_status
    # Faz alterações no status dos pagamentos
    
    salvar_planilha if @parsed
    modificar_status_pagamentos if @parsed && @saved
    salvar_dados_planilha if @saved
  end

  def saved?
    @parsed && @saved && @pagamentos_modificados
  end
  
  def planilha_id 
    @planilha.id
  end

  def validar_data_referencia
    raise "Já existe uma planilha cadastrada com esta data" if Planilha.where(data_referencia: @data_referencia).any?
  end

  def modificar_status_pagamentos
    ActiveRecord::Base.transaction do 
      @pagamentos.each do |pagamento|
        if Pagamento.where(identificador: pagamento['seu_número']).empty?
          pagamento['pagamento_alterado'] = false
        else
          Pagamento.find_by_identificador(pagamento['seu_número']).update(status: :pago, data_pagamento: @data_referencia, planilha: @planilha.id, valor_pago: pagamento['valor_pago'])
          pagamento['pagamento_alterado'] = true
        end
      end
    end
    @pagamentos_modificados = true
  end

  # def validar_pagamentos_existente
  #   raise "Alguns pagamentos não existem no sistema: #{pagamentos_nao_existentes}" if (@pagamentos.pluck('seu_número') - Pagamento.pluck(:identificador)).any? 
  # end

  def validar_status
    pagos = Pagamento.where(identificador: @pagamentos.pluck('seu_número'), status: :pago)
    raise "Já existem pagamentos com status pago: #{pagos.map { |p| p.identificador }.join(', ')}" if pagos.any?
  end

  def parse_file
    xlsx = Roo::Spreadsheet.open(@tmpfile.path, extension: :xlsx)

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
        
        break if pagamento['nome'].include? 'Totais::::>'

        next unless pagamento['valor_pago'].positive?

        @pagamentos << pagamento
      end
    end

    @parsed = true
  end

  def salvar_planilha
    @planilha = Planilha.create!(tipo: :importacao_caixa, data_referencia: @data_referencia, user_id: @user_id)
    @planilha.arquivo.attach(io: File.open(@tmpfile.path), filename: "Planilha Caixa - #{@data_referencia}.xlsx")
    @saved = true
  end

  def salvar_dados_planilha 
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
        data_referencia: @data_referencia,
        pagamento_alterado: pagamento['pagamento_alterado']
      }
    end
    ActiveRecord::Base.transaction { Importacao.insert_all!(importacao) }
  end

end