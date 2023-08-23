class Cliente < ApplicationRecord
  validates :nome, :cpf_cnpj, :data_nascimento, presence: true
  validates :cpf_cnpj, uniqueness: true

  has_many :contratos
  has_many :pagamentos
end
