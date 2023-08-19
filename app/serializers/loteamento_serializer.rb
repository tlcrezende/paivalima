class LoteamentoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :registro, :tamanho, :lotes, :qnt_lotes, :qtd_lotes_com_contrato, :valor
  def lotes
    object.lotes if instance_options[:show_lotes]
    'depois pesquiso como remover' if !instance_options[:show_lotes]
  end

  #TODO: otimizar query depois para não disparar n+1
  def qnt_lotes 
    object.lotes.count 
  end

  def qtd_lotes_com_contrato
    object.lotes.count
  end

  def valor 
    object.lotes.sum(:valor)
  end

end
