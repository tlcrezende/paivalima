class Api::ClientesController < ApplicationController
  include Paginable

  before_action :set_cliente, only: %i[show update destroy]
  before_action :authenticate_api_user!

  # GET /clientes
  def index
    if params[:simple_index]
      @clientes = Cliente.all.order(:nome).pluck(:id, :nome)
      render json: @clientes.map { |cliente| { id: cliente[0], label: cliente[1] } }
      return
    end


    # @clientes = Cliente.page(current_page).per(per_page)

    # render json: @clientes, meta: meta_attributes(@clientes), adapter: :json
    render json: Queries.clientes_index
  end

  # GET /clientes/1
  def show
    if params[:simple_contratos]
      @cliente = Cliente.find(params[:id])
      @contratos = @cliente.contratos.map do |contrato|
        {
          id: contrato.id,
          label: contrato.lote.loteamento.nome + ' - Lote ' + contrato.lote.numero.to_s,
          valor: contrato.lote.valor,
          montante: contrato.lote.valor - contrato.pagamentos.filter(&:data_pagamento).sum(&:valor), # TODO: Juros
          qtde_parcelas: contrato.qnt_parcelas,
          qtde_parcelas_pagas: contrato.pagamentos.filter(&:data_pagamento).size
        }
      end
      render json: @contratos
      return
    end

    render json: @cliente
  end

  # POST /clientes
  def create
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      render json: { id: @cliente.id }, status: :created
    else
      render json: @cliente.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clientes/1
  def update
    if @cliente.update(cliente_params)
      render json: @cliente
    else
      render json: @cliente.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clientes/1
  def destroy
    @cliente.destroy
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cliente
    @cliente = Cliente.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cliente_params
    params.require(:cliente).permit(:nome, :cpf_cnpj, :data_nascimento, :celular, :endereco)
  end
end
