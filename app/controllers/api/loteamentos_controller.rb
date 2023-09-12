class Api::LoteamentosController < ApplicationController
  before_action :set_loteamento, only: %i[ show update destroy ]

  def index
    # @loteamentos = Loteamento.all

    # render json: @loteamentos
    render json: Queries.loteamentos_index
  end

  def show
    render json: @loteamento, serializer: LoteamentoSerializer, show_lotes: true
  end

  def create
    @loteamento = Loteamento.new(loteamento_params)

    if @loteamento.save
      render json: @loteamento, status: :created
    else
      render json: @loteamento.errors, status: :unprocessable_entity
    end
  end

  def update
    if @loteamento.update(loteamento_params)
      render json: @loteamento
    else
      render json: @loteamento.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @loteamento.destroy
  end

  private
    def set_loteamento
      @loteamento = Loteamento.find(params[:id])
    end

    def loteamento_params
      params.require(:loteamento).permit(:nome, :registro)
    end
end
