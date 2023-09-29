require 'csv'
require 'roo'

class Api::ContratosController < ApplicationController
  include Paginable

  before_action :set_contrato, only: %i[show update destroy]

  # GET /contratos
  def index
    # @contratos = @contratos.page(current_page).per(per_page)

    # render json: @contratos, meta: meta_attributes(@contratos), adapter: :json
    render json: Queries.contratos_index
  end

  # GET /contratos/1
  def show
    render json: @contrato, serializer: ContratoSerializer, show_pagamentos: true
  end

  # POST /contratos
  def create
    @contrato = Contrato.new(contrato_params)

    if @contrato.save
      render json: @contrato, status: :created
    else
      render json: @contrato.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contratos/1
  def update
    if @contrato.update(contrato_params)
      render json: @contrato
    else
      render json: @contrato.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contratos/1
  def destroy
    @contrato.destroy
  end

  def upload_arquivo
    @contrato = Contrato.find(params[:id])
    @contrato.arquivos.attach(params[:file])

    render json: { message: 'Arquivo salvo com sucesso' }, status: :created
  end

  def destroy_arquivo
    @contrato = Contrato.find(params[:id])
    @contrato.arquivos.find(params[:active_storage_attachments_id]).purge

    render json: { message: 'Arquivo removido com sucesso' }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contrato
    @contrato = Contrato.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contrato_params
    params.require(:contrato).permit(
      :lote_id,
      :data_inicio, 
      :datetime, 
      :qnt_parcelas, 
      :integer, 
      :observacao, 
      :descricao, 
      :nome, 
      :apelido, 
      :cpf_cnpj, 
      :data_nascimento, 
      :celular,
      :celular, 
      :cep, 
      :logradouro, 
      :cidade, 
      :uf
    )
  end
end
