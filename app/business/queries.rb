class Queries
  def self.run(query)
    ActiveRecord::Base.connection.execute(query).to_a
  end

  def self.contratos_index
    query = "
      select c.id, c.id contrato_id, c2.nome cliente, concat(l2.nome, ' / ', l.numero) as loteamento_lote, c.data_inicio,
      count(p.data_pagamento) as qtde_parcelas_pagas, count(*) as qtde_parcelas, l.valor

      from contratos c
      inner join lotes l on l.id = c.lote_id
      inner join clientes c2 on c2.id = c.cliente_id
      inner join loteamentos l2 on l2.id = l.loteamento_id
      inner join pagamentos p on p.contrato_id = c.id

      group by c.id, l.id, c2.id, l2.id
    "
    run(query)
  end

  def self.pagamentos_index 
    query = "
      select p.id, p.identificador, c2.nome as nome_cliente, l2.nome as nome_loteamento, l.numero as lote, p.valor, p.status, p.data_vencimento,
      concat(p.ordem, ' / ', c.qnt_parcelas) as parcela
      from pagamentos p
      inner join contratos c on c.id = p.contrato_id
      inner join lotes l on l.id = p.lote_id
      inner join clientes c2 on c2.id = p.cliente_id
      inner join loteamentos l2 on l2.id = l.loteamento_id
      WHERE p.data_vencimento BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE + INTERVAL '6 months';
    "
    run(query)
  end
end
