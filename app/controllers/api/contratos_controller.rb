require 'csv'
require 'roo'

class Api::ContratosController < ApplicationController
  include Paginable

  before_action :set_contrato, only: %i[show update destroy]

  # GET /contratos
  def index
    @contratos = Contrato.page(current_page).per(per_page)

    render json: @contratos, meta: meta_attributes(@contratos), adapter: :json
  end

  # GET /contratos/1
  def show
    render json: @contrato, serializer: ContratoSerializer, show_pagamentos: true
  end

  # POST /contratos
  def create
    @contrato = Contrato.new(contrato_params)

    if @contrato.save
      render json: @contrato, status: :created, location: @contrato
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

  def upload
    tmpfile = Tempfile.new.binmode
    tmpfile << Base64.decode64(params[:file])
    tmpfile.rewind
    xlsx = Roo::Spreadsheet.open(tmpfile.path, extension: :xlsx)

    pagamentos = []
    xlsx.sheets.each do |sheet_name|
      sheet = xlsx.sheet(sheet_name)
      sheet.each_row_streaming(offset: 2) do |row|
        pagamentos << row.map(&:value)
      end
    end

    render json: {
      pagamentos_processados: pagamentos
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contrato
    @contrato = Contrato.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contrato_params
    params.require(:contrato).permit(:lote_id, :cliente_id, :data_inicio, :datetime, :qnt_parcelas, :integer)
  end
end
