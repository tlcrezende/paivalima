class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :nome, :cpf_cnpj, :data_nascimento, :celular, :endereco, :contratos, :pagamentos
end
