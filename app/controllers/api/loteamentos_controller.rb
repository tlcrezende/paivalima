class Api::LoteamentosController < ApplicationController
  before_action :set_loteamento, only: %i[ show update destroy ]

  # GET /loteamentos
  def index
    # @loteamentos = Loteamento.all

    # render json: @loteamentos
    render json: Queries.loteamentos_index
  end

  # GET /loteamentos/1
  def show
    render json: @loteamento, serializer: LoteamentoSerializer, show_lotes: true
  end

  # POST /loteamentos
  def create
    @loteamento = Loteamento.new(loteamento_params)

    if @loteamento.save
      render json: @loteamento, status: :created, location: @loteamento
    else
      render json: @loteamento.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /loteamentos/1
  def update
    if @loteamento.update(loteamento_params)
      render json: @loteamento
    else
      render json: @loteamento.errors, status: :unprocessable_entity
    end
  end

  # DELETE /loteamentos/1
  def destroy
    @loteamento.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loteamento
      @loteamento = Loteamento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loteamento_params
      params.require(:loteamento).permit(:nome, :registro, :tamanho)
    end
end
