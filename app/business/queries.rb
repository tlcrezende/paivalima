class Queries
  def self.run(query)
    ActiveRecord::Base.connection.execute(query).to_a
  end

  def self.clientes_index
    query = "
      select c.id, c.id cliente_id, c.nome cliente_nome,
      coalesce(count(p.data_pagamento), 0) as qtde_pagamentos_recebidos,
      coalesce(count(distinct c2.id), 0) as qtde_contratos_vigentes,
      min(c2.data_inicio) as data_inicio_contratos,
      sum(distinct c2.valor) as valor_contratos,
      coalesce(sum(p.valor_pago), 0) as valor_recebido,
      coalesce((min(p.data_vencimento) filter(where p.data_pagamento is null)) < now(), false) as atrasado

      from clientes c
      left join contratos c2 on c2.cliente_id = c.id
      left join pagamentos p on p.contrato_id = c2.id
      left join lotes l on l.id = c2.lote_id

      group by c.id
    "
    run(query)
  end

  def self.loteamentos_index
    query = "
      select l.id, l.nome, l.registro,
      count(distinct l2.id) as qtde_lotes,
      sum(distinct c.valor) as valor,
      coalesce(sum(p.valor) filter(where p.status = 1), 0) as valor_arrecadado,
      count(distinct l2.id) filter(where c.id is not null) as qtde_lotes_com_contrato

      from loteamentos l
      left join lotes l2 on l2.loteamento_id = l.id
      left join contratos c on c.lote_id = l2.id
      left join pagamentos p on p.contrato_id = c.id

      group by l.id
    "
    run(query)
  end

  def self.loteamentos_show(loteamento_id)
    query = "
      select l.numero , l.tamanho, count(p.status) filter(where p.status = 1) as qtde_parcelas_recebidas,
      count(p.id) as qtde_parcelas,
      sum(p.valor_pago) filter(where p.status = 1) as valor_recebido,
      c.valor as valor_contrato
      from loteamentos l2 
      left join lotes l on l.loteamento_id = l2.id 
      left join contratos c on c.lote_id = l.id
      left join pagamentos p on p.lote_id = l.id
      where l2.id = #{loteamento_id}
      group by l.id, c.valor
      order by l.numero 
    "
    run(query)
  end

  def self.lotes_index
    query = "
      select l.id, l2.nome loteamento_nome, l.numero, l.tamanho, c.valor, sum(p.valor_pago) as valor_arrecadado

      from lotes l
      inner join loteamentos l2 on l2.id = l.loteamento_id
      inner join contratos c on c.lote_id = l.id
      left join pagamentos p on p.contrato_id = c.id
      group by l.id, l2.nome, l.numero, l.tamanho, c.valor
    "
    run(query)
  end

  def self.contratos_index
    query = "
      select c.id, c.id contrato_id, c2.nome cliente, concat(l2.nome, ' / ', l.numero) as loteamento_lote, c.data_inicio,
      count(p.data_pagamento) as qtde_parcelas_pagas, count(*) as qtde_parcelas, c.valor
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
      concat(p.ordem, ' / ', c.qnt_parcelas) as parcela, p.data_pagamento, p.ordem_carne, p.carne_codigo as carne,
      (select count(distinct p2.id)  from pagamentos p2
      where p.carne_codigo = p2.carne_codigo
      ) as qtde_parcelas_carne
      from pagamentos p
      inner join contratos c on c.id = p.contrato_id
      inner join lotes l on l.id = p.lote_id
      inner join clientes c2 on c2.id = p.cliente_id
      inner join loteamentos l2 on l2.id = l.loteamento_id
      WHERE p.soft_deleted = false
      -- and p.data_vencimento BETWEEN CURRENT_DATE - INTERVAL '2 months' AND CURRENT_DATE + INTERVAL '3 months';
    "
    run(query)
  end

  def self.pagamentos_show(pagamento_id)
    query = "
      select p.id, p.identificador, c2.nome as nome_cliente, l2.nome as nome_loteamento, l.numero as lote, p.valor, p.status, p.data_vencimento,
      concat(p.ordem, ' / ', c.qnt_parcelas) as parcela, p.data_pagamento, p.ordem_carne, p.carne_codigo as carne,
      (select count(distinct p2.id)  from pagamentos p2
      where p.carne_codigo = p2.carne_codigo
      ) as qtde_parcelas_carne
      from pagamentos p
      inner join contratos c on c.id = p.contrato_id
      inner join lotes l on l.id = p.lote_id
      inner join clientes c2 on c2.id = p.cliente_id
      inner join loteamentos l2 on l2.id = l.loteamento_id
      WHERE p.soft_deleted = false and p.id = #{pagamento_id}
      -- and p.data_vencimento BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE + INTERVAL '6 months';
    "
    run(query)
  end
end
