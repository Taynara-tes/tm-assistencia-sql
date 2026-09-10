USE tm_assistencia;

-- 1. Painel operacional: ordens que ainda exigem ação
SELECT os.id_os, c.nome AS cliente, CONCAT(a.marca, ' ', a.modelo) AS aparelho,
       os.status, os.prioridade, os.prazo_estimado,
       CASE WHEN os.prazo_estimado < NOW() THEN 'ATRASADA' ELSE 'NO_PRAZO' END AS situacao_prazo
FROM ordens_servico os
JOIN clientes c ON c.id_cliente = os.id_cliente
JOIN aparelhos a ON a.id_aparelho = os.id_aparelho
WHERE os.status NOT IN ('ENTREGUE', 'CANCELADA')
ORDER BY os.prioridade = 'URGENTE' DESC, os.prazo_estimado;

-- 2. Faturamento mensal e acumulado
WITH faturamento_mensal AS (
    SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes, SUM(valor) AS faturamento
    FROM pagamentos
    WHERE status = 'PAGO'
    GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
)
SELECT mes, faturamento,
       SUM(faturamento) OVER (ORDER BY mes) AS faturamento_acumulado
FROM faturamento_mensal
ORDER BY mes;

-- 3. Ticket médio por forma de pagamento
SELECT forma_pagamento, COUNT(*) AS quantidade_pagamentos,
       ROUND(AVG(valor), 2) AS ticket_medio, SUM(valor) AS total
FROM pagamentos
WHERE status = 'PAGO'
GROUP BY forma_pagamento
ORDER BY total DESC;

-- 4. Serviços mais realizados
SELECT s.nome, SUM(oss.quantidade) AS total_realizado,
       SUM(oss.quantidade * oss.valor_unitario) AS receita_mao_de_obra
FROM os_servicos oss
JOIN servicos s ON s.id_servico = oss.id_servico
GROUP BY s.id_servico, s.nome
ORDER BY total_realizado DESC, receita_mao_de_obra DESC;

-- 5. Marcas e modelos mais atendidos
SELECT a.marca, a.modelo, COUNT(*) AS quantidade_ordens
FROM ordens_servico os
JOIN aparelhos a ON a.id_aparelho = os.id_aparelho
GROUP BY a.marca, a.modelo
ORDER BY quantidade_ordens DESC, a.marca, a.modelo;

-- 6. Produtividade dos técnicos
SELECT t.nome, COUNT(os.id_os) AS ordens_atribuidas,
       SUM(os.status IN ('CONCLUIDA', 'ENTREGUE')) AS ordens_finalizadas,
       ROUND(AVG(CASE WHEN os.data_conclusao IS NOT NULL
                 THEN TIMESTAMPDIFF(HOUR, os.data_abertura, os.data_conclusao) END), 1)
           AS media_horas_conclusao
FROM tecnicos t
LEFT JOIN ordens_servico os ON os.id_tecnico = t.id_tecnico
GROUP BY t.id_tecnico, t.nome
ORDER BY ordens_finalizadas DESC;

-- 7. Clientes recorrentes
SELECT c.nome, c.telefone, COUNT(os.id_os) AS total_ordens,
       MAX(os.data_abertura) AS ultima_visita
FROM clientes c
JOIN ordens_servico os ON os.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.telefone
HAVING COUNT(os.id_os) > 1
ORDER BY total_ordens DESC;

-- 8. Peças que precisam de reposição
SELECT sku, nome, estoque_atual, estoque_minimo,
       estoque_minimo - estoque_atual AS quantidade_sugerida
FROM pecas
WHERE estoque_atual < estoque_minimo
ORDER BY quantidade_sugerida DESC;

-- 9. Valor completo de cada ordem: serviços + peças
SELECT os.id_os, c.nome AS cliente,
       COALESCE(s.total_servicos, 0) AS total_servicos,
       COALESCE(p.total_pecas, 0) AS total_pecas,
       COALESCE(s.total_servicos, 0) + COALESCE(p.total_pecas, 0) AS valor_total
FROM ordens_servico os
JOIN clientes c ON c.id_cliente = os.id_cliente
LEFT JOIN (
    SELECT id_os, SUM(quantidade * valor_unitario) AS total_servicos
    FROM os_servicos GROUP BY id_os
) s ON s.id_os = os.id_os
LEFT JOIN (
    SELECT id_os, SUM(quantidade * valor_unitario) AS total_pecas
    FROM os_pecas GROUP BY id_os
) p ON p.id_os = os.id_os
ORDER BY valor_total DESC;

