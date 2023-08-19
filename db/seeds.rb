# 50.times do 
#   p 'Criando um novo cliente...'
#   Cliente.create(
#     nome: Faker::Name.name,
#     cpf_cnpj: Faker::Number.number(digits: 11),
#     data_nascimento: Faker::Date.birthday(min_age: 18, max_age: 65),
#     celular: Faker::PhoneNumber.cell_phone,
#     endereco: Faker::Address.full_address
#   )
# end

# 10.times do 
#   p 'Criando um novo loteamento...'
#   Loteamento.create(
#     nome: Faker::Address.unique.community,
#     registro: Faker::Number.number(digits: 15),
#     tamanho: Faker::Number.between(from: 50, to: 900)
#   )
# end

# 10.times do |lote|
#   p 'Criando novos lotes um loteamento...'
#   numero_lotes = Faker::Number.between(from: 10, to: 700)
#   p numero_lotes
#   numero_lotes.to_i.times do |i| 
#     p 'Criando novo lote...'
#     Lote.create(
#       loteamento_id: lote,
#       numero: i + 1,
#       valor: Faker::Number.between(from: 50000, to: 1000000),
#       tamanho: Faker::Number.between(from: 1, to: 5)
#     )
#   end
# end

# Cliente.all.count.times do |cliente|
#   p "Criando novo contrato do cliente #{cliente + 1}"
#   lote_id = Faker::Number.between(from: 1, to: 2800)
#   if Lote.find(lote_id).contratos.empty? 
#     Contrato.create(cliente_id: cliente + 1, lote_id: lote_id, data_inicio: Faker::Date.between(from: '2021-01-01', to: '2023-12-31'), qnt_parcelas: Faker::Number.between(from: 1, to: 120))
#   end
#   if cliente > 30 
#     p "Criando mais 1 contrato do cliente #{cliente + 1}"
#     lote_id = Faker::Number.between(from: 1, to: 2800)
#     if Lote.find(lote_id).contratos.empty? 
#       Contrato.create(cliente_id: cliente + 1, lote_id: lote_id, data_inicio: Faker::Date.between(from: '2021-01-01', to: '2023-12-31'), qnt_parcelas: Faker::Number.between(from: 1, to: 120))
#     end
#   end
# end
