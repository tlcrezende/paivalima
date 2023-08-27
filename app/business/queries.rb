class Queries
  def self.run(query)
    ActiveRecord::Base.connection.execute(query).to_a
  end

  def self.clientes_index
    query = "
      select c.id, c.id cliente_id, c.nome cliente_nome,
      count(p.data_pagamento) as qtde_pagamentos_recebidos,
      count(distinct c2.id) as qtde_contratos_vigentes,
      min(c2.data_inicio) as data_inicio_contratos,
      sum(p.valor) filter(where p.data_pagamento is not null) as valor_recebido,
      (min(p.data_vencimento) filter(where p.data_pagamento is null)) < now() as atrasado

      from clientes c
      inner join contratos c2 on c2.cliente_id = c.id
      inner join pagamentos p on p.contrato_id = c2.id
      inner join lotes l on l.id = c2.lote_id

      group by c.id
    "
    run(query)
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
end
