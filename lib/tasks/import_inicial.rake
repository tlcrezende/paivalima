namespace :import do
  task :inicial => :environment do 

    data_path  = 'files/contratos.json'
    data_json = File.open(data_path).read
    data = JSON.parse(data_json, symbolize_names: true)

    # {
    #   "codigo_henning": 177201,
    #   "descricao": "ROGERIO EMIDIO SANTOS - 1772012 (SERRA DO GAVIAO)",
    #   "apelido": null,
    #   "telefone": null,
    #   "cpf": "89429001434",
    #   "observacao": null,
    #   "nome": "ROGERIO EMIDIO SANTOS",
    #   "rg": "990.012.420.58",
    #   "cep": "57.442-000",
    #   "logradouro": "Rua Aureliano de Abreu",
    #   "cidade": "Olho D\u2019\u00c1gua das Flores",
    #   "UF": "AL",
    #   "nome_terreno": "Chacaras MARRUA",
    #   "numero_lote": 13,
    #   "tamanho_lote": 3030.0,
    #   "montante": 41570.0,
    #   "qtde_parcelas": 168,
    #   "data_inicio_contrato": "2020\/11\/27",
    #   "price": 0.00343,
    #   "file": "drive\/MyDrive\/SoftBuilders\/Dados Paiva&Lima\/CONTRATO  CHAC. MARRUA\/ROGERIO EMIDIO SANTOS - 1.docx",
    data.each do |d|
      cliente = Cliente.find_by(cpf_cnpj: d[:cpf])
      if cliente.nil? 
        p "Criando cliente #{d[:nome]}"
        cliente = Cliente.create(
          nome: d[:nome], 
          cpf_cnpj: d[:cpf], 
          rg: d[:rg], 
          cep: d[:cep], 
          logradouro: d[:logradouro], 
          cidade: d[:cidade], 
          uf: d[:UF], 
          celular: d[:telefone],
          apelido: d[:apelido]
        )
      end
      loteamento = Loteamento.find_by(nome: d[:nome_terreno])
      if loteamento.nil?
        p "Criando loteamento #{d[:nome_terreno]}"
        loteamento = Loteamento.create(nome: d[:nome_terreno])
      end
      lote = Lote.find_by(numero: d[:numero_lote])
      if lote.nil?
        p "Criando lote #{d[:numero_lote]}"
        lote = Lote.create(numero: d[:numero_lote], tamanho: d[:tamanho_lote], loteamento_id: loteamento.id)
      else
        p "Lote #{d[:numero_lote]} já existe, algo errado...."
        # byebug
      end
      contrato = Contrato.find_by(hennering_code: d[:codigo_henning])
      if contrato.nil?
        p "Criando contrato #{d[:codigo_henning]}"
        Contrato.create(
          data_inicio: d[:data_inicio_contrato], 
          qnt_parcelas: d[:qtde_parcelas], 
          valor: d[:montante], 
          hennering_code: d[:codigo_henning], 
          lote_id: lote.id, 
          cliente_id: cliente.id,
          observacao: d[:observacao],
          descricao: d[:descricao]
        )
      else 
        p "Contrato #{d[:codigo]} já existe, algo errado...."
        # byebug
      end
    end
  end
end
