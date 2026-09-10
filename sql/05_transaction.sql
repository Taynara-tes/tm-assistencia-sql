USE tm_assistencia;

-- Exemplo: vincular uma peça à OS e baixar o estoque de forma atômica.
-- Altere os valores das variáveis antes de usar em produção.
SET @id_os = 7;
SET @id_peca = 3;
SET @quantidade = 1;

START TRANSACTION;

SELECT estoque_atual
FROM pecas
WHERE id_peca = @id_peca
FOR UPDATE;

INSERT INTO os_pecas (id_os, id_peca, quantidade, valor_unitario)
SELECT @id_os, id_peca, @quantidade, preco_venda
FROM pecas
WHERE id_peca = @id_peca
  AND estoque_atual >= @quantidade;

UPDATE pecas
SET estoque_atual = estoque_atual - @quantidade
WHERE id_peca = @id_peca
  AND estoque_atual >= @quantidade
  AND ROW_COUNT() = 1;

-- Antes do COMMIT, confira se a peça foi incluída e o estoque foi atualizado.
COMMIT;

