require 'csv'

class Api::ExportacoesController < ApplicationController
  def create
    url = PlanilhaContabilidade.gerar(params[:data_inicio], params[:data_fim])
    render json: { url: url }
  end

  #   CSV.open(file, "wb", write_headers: true, headers: headers, col_sep: ',') do |writer|
  #   end
  # end
end
