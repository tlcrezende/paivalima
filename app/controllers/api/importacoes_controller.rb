class Api::ImportacoesController < ApplicationController
  include Paginable

  before_action :authenticate_api_user!

  def index
    @planilhas = Planilha.where(tipo: :importacao_caixa).order(:data_referencia).page(current_page).per(per_page)
    render json: @planilhas, meta: meta_attributes(@planilhas), adapter: :json
  end

  def create
    importacao = ImportacaoLogic.new(params[:file], current_api_user.id, params[:data_referencia] || Time.zone.now)
    importacao.importar_dados
  
    render json: {id: importacao.planilha_id}, status: :created if importacao.saved?
	rescue StandardError => e
		render json: {message: "Erro na importação da planilha - #{e}"}, status: :unprocessable_entity
  end

  def show
		pagamentos_processados = Importacao.where(planilha_id: params[:id])
    url = Planilha.find(params[:id]).arquivo_url

    render json: { pagamentos_processados: pagamentos_processados, url: url }
  end
end

