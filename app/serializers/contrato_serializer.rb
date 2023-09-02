class ContratoSerializer < ActiveModel::Serializer
  attributes :id, :data_inicio, :qnt_parcelas, :qtde_parcelas_pagas, :pagamentos, :valor
  has_one :lote
  has_one :cliente

  def qtde_parcelas_pagas
    object.pagamentos.filter(&:data_pagamento).size
  end

  def pagamentos
    return nil unless instance_options[:show_pagamentos].present?

    object.pagamentos
  end
end
