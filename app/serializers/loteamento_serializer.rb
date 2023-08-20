class LoteamentoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :registro, :tamanho, :lotes, :qtde_lotes, :qtde_lotes_com_contrato, :valor, :valor_arrecadado
  def lotes
    object.lotes if instance_options[:show_lotes]
    'depois pesquiso como remover' unless instance_options[:show_lotes]
  end

  # TODO: otimizar query depois para não disparar n+1
  def qtde_lotes
    object.lotes.count
  end

  def qtde_lotes_com_contrato
    object.contratos.count
  end

  def valor
    object.lotes.sum(:valor)
  end

  Contrato.includes(:lote, :pagamentos)
  def valor_arrecadado
    object.lotes.includes(contratos: :pagamentos).map(&:contratos).flatten.map(&:pagamentos).flatten.sum(&:valor)
  end
end
