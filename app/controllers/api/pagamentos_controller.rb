class Api::PagamentosController < ApplicationController
  before_action :set_pagamento, only: %i[ show update destroy ]

  # GET /pagamentos
  def index
    @pagamentos = Pagamento.all

    render json: @pagamentos
  end

  # GET /pagamentos/1
  def show
    render json: @pagamento
  end

  # POST /pagamentos
  def create
    @pagamento = Pagamento.new(pagamento_params)

    if @pagamento.save
      render json: @pagamento, status: :created, location: @pagamento
    else
      render json: @pagamento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pagamentos/1
  def update
    if @pagamento.update(pagamento_params)
      render json: @pagamento
    else
      render json: @pagamento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pagamentos/1
  def destroy
    @pagamento.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagamento
      @pagamento = Pagamento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pagamento_params
      params.require(:pagamento).permit(:contrato_id, :cliente_id, :lote_id, :data_vencimento, :valor, :status, :identificador, :data_pagamento)
    end
end
