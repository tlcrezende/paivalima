class Api::ClientesController < ApplicationController
  include Paginable

  before_action :set_cliente, only: %i[show update destroy]
  before_action :authenticate_api_user!

  # GET /clientes
  def index
    @clientes = Cliente.page(current_page).per(per_page)

    render json: @clientes, meta: meta_attributes(@clientes), adapter: :json
  end

  # GET /clientes/1
  def show
    render json: @cliente
  end

  # POST /clientes
  def create
    @cliente = Cliente.new(cliente_params)

    if @cliente.save
      render json: @cliente, status: :created, location: @cliente
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

  def all_clientes
    @clientes = Cliente.all.order(:nome).pluck(:id, :nome)
    render json: @clientes
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
  def set_cliente
    @cliente = Cliente.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cliente_params
    params.require(:cliente).permit(:nome, :cpf_cnpj, :data_nascimento, :celular, :endereco)
  end
end
