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

  def self.loteamentos_index
    query = "
      select l.id, l.nome, l.registro, l.tamanho, l.valor,
      count(distinct l2.id) as qtde_lotes,
      coalesce(sum(p.valor) filter(where p.data_pagamento is not null), 0) as valor_arrecadado,
      coalesce(sum(l2.valor), 0) as valor_total,
      count(distinct l2.id) filter(where c.id is not null) as qtde_lotes_com_contrato

      from loteamentos l
      left join lotes l2 on l2.loteamento_id = l.id
      left join contratos c on c.lote_id = l2.id
      left join pagamentos p on p.contrato_id = c.id

      group by l.id
    "
    run(query)
  end

  def self.lotes_index
    query = "
      select l.id, l2.nome loteamento_nome, l.numero, l.tamanho, l.valor

      from lotes l
      inner join loteamentos l2 on l2.id = l.loteamento_id
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

  def self.pagamentos_index
    query = "
      select p.id, p.identificador, c2.nome as nome_cliente, l2.nome as nome_loteamento, l.numero as lote, p.valor, p.status, p.data_vencimento,
      concat(p.ordem, ' / ', c.qnt_parcelas) as parcela
      from pagamentos p
      inner join contratos c on c.id = p.contrato_id
      inner join lotes l on l.id = p.lote_id
      inner join clientes c2 on c2.id = p.cliente_id
      inner join loteamentos l2 on l2.id = l.loteamento_id
      WHERE p.data_vencimento BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE + INTERVAL '6 months'
      and p.soft_deleted = false;
    "
    run(query)
  end
end
