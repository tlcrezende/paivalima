class LoteSerializer < ActiveModel::Serializer
  attributes :id, :numero, :valor, :tamanho, :qtde_pagamentos_recebidos, :qtde_pagamentos, :valor_recebido

  has_one :loteamento

  def qtde_pagamentos_recebidos
    object.pagamentos.filter(&:data_pagamento).count
  end

  def qtde_pagamentos
    object.pagamentos.count
  end

  def valor_recebido
    object.pagamentos.filter(&:data_pagamento).sum(&:valor)
  end
end
