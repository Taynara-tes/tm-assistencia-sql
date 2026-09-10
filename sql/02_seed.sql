USE tm_assistencia;

INSERT INTO clientes (nome, telefone, email) VALUES
('Ana Ribeiro', '32999990001', 'ana.ribeiro@email.com'),
('Bruno Martins', '32999990002', 'bruno.martins@email.com'),
('Carla Souza', '32999990003', 'carla.souza@email.com'),
('Diego Lima', '32999990004', 'diego.lima@email.com'),
('Elisa Fernandes', '32999990005', 'elisa.fernandes@email.com'),
('Felipe Rocha', '32999990006', NULL);

INSERT INTO aparelhos (id_cliente, marca, modelo, imei, cor) VALUES
(1, 'Apple', 'iPhone 13', '350000000000001', 'Azul'),
(2, 'Samsung', 'Galaxy S23', '350000000000002', 'Preto'),
(3, 'Motorola', 'Moto G84', '350000000000003', 'Vermelho'),
(4, 'Xiaomi', 'Redmi Note 12', '350000000000004', 'Cinza'),
(5, 'Apple', 'iPhone 11', '350000000000005', 'Branco'),
(1, 'Samsung', 'Galaxy A54', '350000000000006', 'Verde'),
(6, 'Samsung', 'Galaxy S21', '350000000000007', 'Violeta');

INSERT INTO tecnicos (nome, especialidade) VALUES
('Marcos Alves', 'Microssolda e placas'),
('Juliana Costa', 'Telas e baterias'),
('Renato Gomes', 'Software e diagnóstico');

INSERT INTO servicos (nome, descricao, preco_base) VALUES
('Troca de tela', 'Substituição do conjunto frontal', 180.00),
('Troca de bateria', 'Substituição e teste da bateria', 100.00),
('Reparo de conector', 'Reparo ou troca do conector de carga', 140.00),
('Reparo em placa', 'Diagnóstico e microssolda', 250.00),
('Atualização de software', 'Backup e atualização do sistema', 80.00),
('Limpeza técnica', 'Limpeza interna e remoção de oxidação leve', 90.00);

INSERT INTO pecas (nome, sku, custo_unitario, preco_venda, estoque_atual, estoque_minimo) VALUES
('Tela iPhone 13', 'TEL-IP13', 430.00, 650.00, 3, 2),
('Bateria Galaxy S23', 'BAT-S23', 120.00, 240.00, 4, 2),
('Conector Moto G84', 'CON-MG84', 38.00, 110.00, 1, 2),
('Tela Redmi Note 12', 'TEL-RN12', 210.00, 390.00, 2, 2),
('Bateria iPhone 11', 'BAT-IP11', 95.00, 210.00, 5, 2),
('Conector Galaxy A54', 'CON-A54', 45.00, 120.00, 1, 2);

INSERT INTO ordens_servico
(id_cliente, id_aparelho, id_tecnico, defeito_relatado, diagnostico, status, prioridade, data_abertura, prazo_estimado, data_conclusao, data_entrega) VALUES
(1, 1, 2, 'Tela quebrada após queda', 'Display sem imagem', 'ENTREGUE', 'NORMAL', '2026-07-03 09:10:00', '2026-07-04 17:00:00', '2026-07-04 14:30:00', '2026-07-04 17:20:00'),
(2, 2, 2, 'Bateria descarrega rápido', 'Bateria com baixa saúde', 'CONCLUIDA', 'ALTA', '2026-07-12 10:00:00', '2026-07-13 15:00:00', '2026-07-13 11:40:00', NULL),
(3, 3, 1, 'Não carrega', 'Conector danificado', 'AGUARDANDO_PECA', 'NORMAL', '2026-08-02 13:20:00', '2026-08-05 18:00:00', NULL, NULL),
(4, 4, 2, 'Tela piscando', 'Falha no display', 'EM_REPARO', 'URGENTE', '2026-08-15 08:50:00', '2026-08-16 17:00:00', NULL, NULL),
(5, 5, 2, 'Bateria estufada', 'Substituição imediata recomendada', 'ENTREGUE', 'URGENTE', '2026-08-20 09:30:00', '2026-08-20 16:00:00', '2026-08-20 13:10:00', '2026-08-20 15:00:00'),
(1, 6, 1, 'Falha no conector de carga', 'Conector oxidado', 'ENTREGUE', 'NORMAL', '2026-09-01 11:15:00', '2026-09-03 17:00:00', '2026-09-02 16:40:00', '2026-09-03 10:20:00'),
(6, 7, 3, 'Travando após atualização', 'Necessária restauração do sistema', 'EM_ANALISE', 'NORMAL', '2026-09-08 14:00:00', '2026-09-10 18:00:00', NULL, NULL);

INSERT INTO os_servicos (id_os, id_servico, quantidade, valor_unitario) VALUES
(1, 1, 1, 180.00), (2, 2, 1, 100.00), (3, 3, 1, 140.00),
(4, 1, 1, 180.00), (5, 2, 1, 100.00), (6, 3, 1, 140.00),
(6, 6, 1, 90.00), (7, 5, 1, 80.00);

INSERT INTO os_pecas (id_os, id_peca, quantidade, valor_unitario) VALUES
(1, 1, 1, 650.00), (2, 2, 1, 240.00), (3, 3, 1, 110.00),
(4, 4, 1, 390.00), (5, 5, 1, 210.00), (6, 6, 1, 120.00);

INSERT INTO pagamentos (id_os, valor, forma_pagamento, status, data_pagamento, parcelas) VALUES
(1, 830.00, 'CREDITO', 'PAGO', '2026-07-04 17:15:00', 3),
(2, 340.00, 'PIX', 'PAGO', '2026-07-13 11:45:00', 1),
(5, 310.00, 'DEBITO', 'PAGO', '2026-08-20 14:55:00', 1),
(6, 350.00, 'PIX', 'PAGO', '2026-09-03 10:15:00', 1),
(4, 570.00, 'CREDITO', 'PENDENTE', NULL, 2);

