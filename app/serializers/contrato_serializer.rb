class ContratoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :qnt_parcelas, :qtde_parcelas_pagas, :pagamentos, :valor, :observacao, :descricao, :arquivos
  has_one :lote
  has_one :cliente

  def qtde_parcelas_pagas
    object.pagamentos.filter(&:data_pagamento).size
  end

  def pagamentos
    return nil unless instance_options[:show_pagamentos].present?

    object.pagamentos
  end

  def arquivos
    object.arquivos.map do |arquivo|
      {
        id: arquivo.id,
        filename: arquivo.filename,
        content_type: arquivo.content_type,
        byte_size: arquivo.byte_size,
        url: arquivo.blob.url,
        created_at: arquivo.created_at
      }
    end
  end
end
