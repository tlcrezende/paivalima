class LoteamentoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :registro, :tamanho, :lotes

  def lotes
    object.lotes if instance_options[:show_lotes]
  end
end
