class Api::PagamentosController < ApplicationController
  include Paginable

  before_action :set_pagamento, only: %i[show update destroy]

  # GET /pagamentos
  def index
    @pagamentos = Pagamento.page(current_page).per(per_page)

    render json: @pagamentos, meta: meta_attributes(@pagamentos), adapter: :json
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


  def all_clientes
    @clients = Cliente.all.order(:nome).pluck(:id, :nome)
    render json: @clients
  end

  def all_contratos
    @cliente = Cliente.find(params[:id])
    @cliente = @cliente.contratos.joins(:lote).joins(lote: :loteamento)
                       .order('loteamentos.nome', 'lotes.numero')
                       .pluck(:id, Arel.sql("concat(loteamentos.nome, ' - Lote ', lotes.numero)"))
    render json: @cliente
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
