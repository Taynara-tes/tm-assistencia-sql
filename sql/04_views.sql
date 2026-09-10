USE tm_assistencia;

CREATE OR REPLACE VIEW vw_resumo_ordens AS
SELECT os.id_os, os.data_abertura, os.status, os.prioridade,
       c.nome AS cliente, c.telefone,
       CONCAT(a.marca, ' ', a.modelo) AS aparelho,
       t.nome AS tecnico,
       COALESCE(s.total_servicos, 0) AS total_servicos,
       COALESCE(p.total_pecas, 0) AS total_pecas,
       COALESCE(pg.total_pago, 0) AS total_pago
FROM ordens_servico os
JOIN clientes c ON c.id_cliente = os.id_cliente
JOIN aparelhos a ON a.id_aparelho = os.id_aparelho
LEFT JOIN tecnicos t ON t.id_tecnico = os.id_tecnico
LEFT JOIN (
    SELECT id_os, SUM(quantidade * valor_unitario) AS total_servicos
    FROM os_servicos GROUP BY id_os
) s ON s.id_os = os.id_os
LEFT JOIN (
    SELECT id_os, SUM(quantidade * valor_unitario) AS total_pecas
    FROM os_pecas GROUP BY id_os
) p ON p.id_os = os.id_os
LEFT JOIN (
    SELECT id_os, SUM(valor) AS total_pago
    FROM pagamentos WHERE status = 'PAGO' GROUP BY id_os
) pg ON pg.id_os = os.id_os;

CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       COUNT(*) AS pagamentos,
       ROUND(AVG(valor), 2) AS ticket_medio,
       SUM(valor) AS faturamento
FROM pagamentos
WHERE status = 'PAGO'
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m');

CREATE OR REPLACE VIEW vw_alerta_estoque AS
SELECT id_peca, sku, nome, estoque_atual, estoque_minimo,
       GREATEST(estoque_minimo - estoque_atual, 0) AS quantidade_repor
FROM pecas
WHERE estoque_atual <= estoque_minimo;

