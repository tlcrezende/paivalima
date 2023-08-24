require 'roo'

class Api::ImportacoesController < ApplicationController
  include Paginable

  before_action :authenticate_api_user!

  def index
    @planilhas = Planilha.where(tipo: :importacao_caixa).page(current_page).per(per_page)

    render json: @planilhas, meta: meta_attributes(@planilhas), adapter: :json
  end

  def create
    importacao = ImportacaoLogic.new(params[:file], current_api_user.id, params[:data_referencia] || Time.zone.now)
    importacao.importar_dados
    
		if importacao.saved? 
			render json: {id: importacao.planilha_id}, status: :created
		else
			render json: {message: "Já existe uma planilha cadastrada com esta data"}, status: :unprocessable_entity
		end
	rescue StandardError => e
		render json: {message: "Erro na importação da planilha - #{e}"}, status: :unprocessable_entity
  end

  def show
    planilha = Planilha.find(params[:id])
    pagamentos_processados = [
      {
          "id": 1,
          "nome": "AILSON MELO DOS SANTOS",
          "seu_número": "146D015/008",
          "nosso_numero": "14/000000000024817",
          "valor": 228.51,
          "valor_pago": 228.51,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 3,
          "nome": "ANDERSON FRANCISCO DOS SANTOS  SILVA",
          "seu_número": "152014B/007",
          "nosso_numero": "14/000000000026252",
          "valor": 2558.13,
          "valor_pago": 2558.13,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 4,
          "nome": "AURELINA DE MATOS DA SILVA",
          "seu_número": "202026C/005",
          "nosso_numero": "14/000000000027568",
          "valor": 419.03,
          "valor_pago": 419.03,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 5,
          "nome": "BRENDA LAURENTINO DA SILVA",
          "seu_número": "202348/002",
          "nosso_numero": "14/000000000029631",
          "valor": 281.66,
          "valor_pago": 281.66,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 6,
          "nome": "BRENDA LAURENTINO DA SILVA",
          "seu_número": "202349/002",
          "nosso_numero": "14/000000000029634",
          "valor": 233.33,
          "valor_pago": 233.33,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 7,
          "nome": "CARLINE DANTAS DOS SANTOS",
          "seu_número": "202310A/001",
          "nosso_numero": "14/000000000030852",
          "valor": 386.9,
          "valor_pago": 386.9,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 8,
          "nome": "CHRISTIANO ALVES NOBRE",
          "seu_número": "000022D/009",
          "nosso_numero": "14/000000000024789",
          "valor": 160.37,
          "valor_pago": 160.37,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 9,
          "nome": "CHRISTIANO ALVES NOBRE 1",
          "seu_número": "000034D/009",
          "nosso_numero": "14/000000000024634",
          "valor": 161.54,
          "valor_pago": 161.54,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 10,
          "nome": "CHRISTIANO ALVES NOBRE 2",
          "seu_número": "000025D/009",
          "nosso_numero": "14/000000000024610",
          "valor": 161.54,
          "valor_pago": 161.54,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 11,
          "nome": "CHRISTIANO ALVES NOBRE 3",
          "seu_número": "000026D/009",
          "nosso_numero": "14/000000000024622",
          "valor": 161.54,
          "valor_pago": 161.54,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 12,
          "nome": "CICERO AMORIM NERI",
          "seu_número": "472015D/006",
          "nosso_numero": "14/000000000027046",
          "valor": 300.46,
          "valor_pago": 316.08,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 13,
          "nome": "CICERO CAMILO DOS SANTOS",
          "seu_número": "242014D/003",
          "nosso_numero": "14/000000000029430",
          "valor": 249.18,
          "valor_pago": 249.18,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 14,
          "nome": "CICERO NETO RAMOS - 1",
          "seu_número": "022020D/007",
          "nosso_numero": "14/000000000026180",
          "valor": 151.15,
          "valor_pago": 151.15,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 15,
          "nome": "CICERO NETO RAMOS - 2",
          "seu_número": "032020D/007",
          "nosso_numero": "14/000000000026168",
          "valor": 133.61,
          "valor_pago": 133.61,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 16,
          "nome": "DEBORA DA SILVA MACIEL",
          "seu_número": "201907D/007",
          "nosso_numero": "14/000000000025848",
          "valor": 237.67,
          "valor_pago": 250.03,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 17,
          "nome": "DIEGES ALVES OLIVEIRA - 1",
          "seu_número": "522016C/012",
          "nosso_numero": "14/000000000023087",
          "valor": 126.17,
          "valor_pago": 126.17,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 18,
          "nome": "DIEGES ALVES OLIVEIRA - 2",
          "seu_número": "542016B/012",
          "nosso_numero": "14/000000000023111",
          "valor": 126.17,
          "valor_pago": 126.17,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 19,
          "nome": "DIEGES ALVES OLIVEIRA - 3",
          "seu_número": "532016C/012",
          "nosso_numero": "14/000000000023099",
          "valor": 126.17,
          "valor_pago": 126.17,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 20,
          "nome": "DIEGES ALVES OLIVEIRA - 4",
          "seu_número": "201656D/012",
          "nosso_numero": "14/000000000023123",
          "valor": 122.1,
          "valor_pago": 122.1,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 21,
          "nome": "DIEGES ALVES OLIVEIRA - 5",
          "seu_número": "92017D/012",
          "nosso_numero": "14/000000000023135",
          "valor": 121.63,
          "valor_pago": 121.63,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 24,
          "nome": "ELIAS DA SILVA",
          "seu_número": "592022A/010",
          "nosso_numero": "14/000000000024065",
          "valor": 133.37,
          "valor_pago": 133.37,
          "vencimento": "2023-08-16",
          "situação": "Pago/Baixado"
      },
      {
          "id": 1,
          "nome": "ELIAS FERREIRA DA SILVA",
          "seu_número": "123D015/001",
          "nosso_numero": "14/000000000030251",
          "valor": 344.35,
          "valor_pago": 344.35,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 2,
          "nome": "ELIEUDO VIEIRA BARROS",
          "seu_número": "152017D/006",
          "nosso_numero": "14/000000000026756",
          "valor": 320.7,
          "valor_pago": 320.7,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 3,
          "nome": "FARLIS RODRIGUES CORREIA 1",
          "seu_número": "982015H/007",
          "nosso_numero": "14/000000000024266",
          "valor": 324.71,
          "valor_pago": 324.71,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 4,
          "nome": "FRANCISCO BARBOSA DA SILVA",
          "seu_número": "702014E/008",
          "nosso_numero": "14/000000000025362",
          "valor": 271.8,
          "valor_pago": 271.8,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 5,
          "nome": "GILMAR RODRIGUES MATIAS - 4",
          "seu_número": "332025C/002",
          "nosso_numero": "14/000000000030237",
          "valor": 152.59,
          "valor_pago": 161.12,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 6,
          "nome": "HALLYSON MIGUEL DA SILVA - 1",
          "seu_número": "0000E66/009",
          "nosso_numero": "14/000000000024842",
          "valor": 130.05,
          "valor_pago": 130.05,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 7,
          "nome": "HALLYSON MIGUEL DA SILVA - 2",
          "seu_número": "342022B/003",
          "nosso_numero": "14/000000000029083",
          "valor": 183.28,
          "valor_pago": 183.28,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 8,
          "nome": "HELIOMAR DA SILVA ALMEIDA",
          "seu_número": "52018D/003",
          "nosso_numero": "14/000000000029072",
          "valor": 267.0,
          "valor_pago": 267.0,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 10,
          "nome": "IVANILSON LIMA DOS SANTOS",
          "seu_número": "162016D/007",
          "nosso_numero": "14/000000000026126",
          "valor": 432.17,
          "valor_pago": 432.17,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 11,
          "nome": "IVANIO BARBOSA DE CAMPOS",
          "seu_número": "602022A/010",
          "nosso_numero": "14/000000000024077",
          "valor": 133.37,
          "valor_pago": 133.37,
          "vencimento": "2023-08-16",
          "situação": "Pago/Baixado"
      },
      {
          "id": 14,
          "nome": "JOAO ANTONIO QUINTELA MACHADO",
          "seu_número": "132102B/008",
          "nosso_numero": "14/000000000025537",
          "valor": 661.99,
          "valor_pago": 661.99,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 16,
          "nome": "JOSE DARIO DE ANDRADE",
          "seu_número": "000070E/004",
          "nosso_numero": "14/000000000028288",
          "valor": 148.98,
          "valor_pago": 148.98,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 17,
          "nome": "JOSE DE LIMA PEREIRA",
          "seu_número": "201906D/007",
          "nosso_numero": "14/000000000026090",
          "valor": 205.34,
          "valor_pago": 205.34,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 19,
          "nome": "JOSE LUIS DE LIMA",
          "seu_número": "222016D/001",
          "nosso_numero": "14/000000000030873",
          "valor": 178.01,
          "valor_pago": 178.01,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 21,
          "nome": "JOSE ROBERTO DA SILVA GOMES",
          "seu_número": "682016F/003",
          "nosso_numero": "14/000000000027891",
          "valor": 150.68,
          "valor_pago": 150.68,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 22,
          "nome": "LAIS DA SILVA COSTA",
          "seu_número": "102023A/003",
          "nosso_numero": "14/000000000029161",
          "valor": 905.3,
          "valor_pago": 905.3,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 2,
          "nome": "LUZIA MIZAEL FERREIRA",
          "seu_número": "592014E/010",
          "nosso_numero": "14/000000000023884",
          "valor": 268.83,
          "valor_pago": 268.83,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 3,
          "nome": "LUZIA MIZAEL FERREIRA",
          "seu_número": "582014D/010",
          "nosso_numero": "14/000000000023872",
          "valor": 268.83,
          "valor_pago": 268.83,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 5,
          "nome": "MARIA DE FATIMA ABREU TORRES",
          "seu_número": "201535D/009",
          "nosso_numero": "14/000000000025090",
          "valor": 147.24,
          "valor_pago": 147.24,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 7,
          "nome": "MARIA NEIDE SOARES NOBRE",
          "seu_número": "141D015/004",
          "nosso_numero": "14/000000000028222",
          "valor": 439.35,
          "valor_pago": 439.35,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 11,
          "nome": "MARKLIS ANTONIO DA ROCHA",
          "seu_número": "182017B/011",
          "nosso_numero": "14/000000000024054",
          "valor": 175.2,
          "valor_pago": 184.13,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 12,
          "nome": "MARQUES PEREIRA SILVA",
          "seu_número": "201547D/002",
          "nosso_numero": "14/000000000029978",
          "valor": 172.53,
          "valor_pago": 172.53,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 13,
          "nome": "PEDRO RIBEIRO  CRUZ",
          "seu_número": "352017B/008",
          "nosso_numero": "14/000000000025480",
          "valor": 555.0,
          "valor_pago": 555.0,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 14,
          "nome": "PEDRO VIANA BONFIM NETO",
          "seu_número": "1102022/009",
          "nosso_numero": "14/000000000024717",
          "valor": 182.29,
          "valor_pago": 182.29,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 15,
          "nome": "PHELLIPE BRUNO TELECIO DA SILVA",
          "seu_número": "202322/003",
          "nosso_numero": "14/000000000029023",
          "valor": 233.33,
          "valor_pago": 233.33,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 16,
          "nome": "RAYANE BEZERRA AGRA SILVA",
          "seu_número": "000062B/010",
          "nosso_numero": "14/000000000024221",
          "valor": 142.7,
          "valor_pago": 142.7,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 17,
          "nome": "RICARDO MEDEIROS ROSA",
          "seu_número": "042021B/012",
          "nosso_numero": "14/000000000023147",
          "valor": 250.72,
          "valor_pago": 250.72,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 18,
          "nome": "RITA MARIA BEZERRA SILVA -1",
          "seu_número": "000C57/001",
          "nosso_numero": "14/000000000030888",
          "valor": 167.63,
          "valor_pago": 177.03,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 20,
          "nome": "ROBSON FRANCISCO DOS SANTOS QD H  LT 08",
          "seu_número": "392015G/007",
          "nosso_numero": "14/000000000026276",
          "valor": 296.45,
          "valor_pago": 296.45,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 21,
          "nome": "ROSALINO CATARINO DE SOUZA",
          "seu_número": "201985D/011",
          "nosso_numero": "14/000000000023405",
          "valor": 248.63,
          "valor_pago": 248.63,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 22,
          "nome": "ROSANGELA ROCHA WANDERLEY",
          "seu_número": "201981B/011",
          "nosso_numero": "14/000000000023699",
          "valor": 311.21,
          "valor_pago": 311.21,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 23,
          "nome": "ROSE KATIANNE MAURICIO SANTOS",
          "seu_número": "202345/003",
          "nosso_numero": "14/000000000029596",
          "valor": 205.36,
          "valor_pago": 205.36,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 2,
          "nome": "SELMA ALEXANDRE DA SILVA VIEIRA",
          "seu_número": "402015D/007",
          "nosso_numero": "14/000000000026192",
          "valor": 296.45,
          "valor_pago": 296.45,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      },
      {
          "id": 3,
          "nome": "SERGIO VANDERLEI ARAUJO",
          "seu_número": "912015D/005",
          "nosso_numero": "14/000000000027637",
          "valor": 302.87,
          "valor_pago": 302.87,
          "vencimento": "2023-08-15",
          "situação": "Pago/Baixado"
      }
  ] # planilha.pagamentos_processados
    url = planilha.arquivo.blob.url

    render json: { pagamentos_processados: pagamentos_processados, url: url }
  end

  #   CSV.open(file, "wb", write_headers: true, headers: headers, col_sep: ',') do |writer|
  #   end
  # end
end
