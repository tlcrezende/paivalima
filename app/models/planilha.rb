class Planilha < ApplicationRecord
  belongs_to :user
  has_many :importacoes, dependent: :destroy

  validates :data_referencia, presence: true
  
  enum tipo: [:importacao_caixa, :exportacao_contabilidade]

  has_one_attached :arquivo

  def arquivo_url 
    arquivo.blob.url
  end
end
