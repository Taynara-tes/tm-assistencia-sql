# Dicionário de dados

| Tabela | Finalidade | Principais campos |
|---|---|---|
| `clientes` | Identifica quem solicita o atendimento | nome, telefone, e-mail |
| `aparelhos` | Registra os dispositivos de cada cliente | marca, modelo, IMEI, cor |
| `tecnicos` | Mantém a equipe responsável pelos reparos | nome, especialidade, ativo |
| `ordens_servico` | Centraliza o ciclo completo do atendimento | defeito, diagnóstico, status, prioridade e datas |
| `servicos` | Catálogo de mão de obra | nome, descrição e preço-base |
| `os_servicos` | Relaciona serviços executados a cada OS | quantidade e valor praticado |
| `pecas` | Catálogo e estoque de componentes | SKU, custo, preço, estoque atual e mínimo |
| `os_pecas` | Relaciona as peças utilizadas a cada OS | quantidade e valor praticado |
| `pagamentos` | Registra os recebimentos das ordens | valor, forma, status, data e parcelas |

## Regras principais

- Telefone e e-mail evitam duplicidade de clientes quando informados.
- O IMEI é único por aparelho.
- Uma ordem pertence a um cliente e a um aparelho.
- Uma ordem pode conter vários serviços, peças e pagamentos.
- Valores e quantidades não podem ser negativos.
- A exclusão de uma ordem remove apenas seus itens associados; cadastros históricos permanecem protegidos.
- Índices apoiam as pesquisas por status, prazo, data de abertura e pagamento.

## Status da ordem

| Status | Significado |
|---|---|
| `ABERTA` | Atendimento recém-criado |
| `EM_ANALISE` | Aparelho em diagnóstico |
| `AGUARDANDO_APROVACAO` | Orçamento aguardando o cliente |
| `AGUARDANDO_PECA` | Reparo depende de componente |
| `EM_REPARO` | Serviço em execução |
| `CONCLUIDA` | Reparo finalizado |
| `ENTREGUE` | Aparelho devolvido ao cliente |
| `CANCELADA` | Atendimento encerrado sem execução |

