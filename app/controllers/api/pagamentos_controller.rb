class Api::PagamentosController < ApplicationController
  include Paginable
  
  before_action :set_pagamento, only: %i[ show update destroy ]
  before_action :authenticate_api_user!

  def index
    @pagamentos = Pagamento.active.page(current_page).per(per_page)

    render json: @pagamentos, meta: meta_attributes(@pagamentos), adapter: :json
  end

  def show
    render json: @pagamento
  end

  def create
    contrato = Contrato.find(params[:contrato_id])
    pagamentos = PagamentoLogic.new(contrato.id, params[:valor], params[:qtde_parcelas], params[:data_vencimento])
    pagamentos.create_carne

    render json: {carne_codigo: pagamentos.codigo}, status: :created

  end

  def update
    if @pagamento.update(pagamento_params)
      render json: @pagamento
    else
      render json: @pagamento.errors, status: :unprocessable_entity
    end
  end

  def destroy
    #softdelete
    @pagamento.update(soft_deleted: true)
  end

  private
    def set_pagamento
      @pagamento = Pagamento.find(params[:id])
    end

    def pagamento_params
      params.require(:pagamento).permit(:contrato_id, :valor, :qtde_parcelas, :data_vencimento)
    end
end
