DROP DATABASE IF EXISTS tm_assistencia;
CREATE DATABASE tm_assistencia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE tm_assistencia;

CREATE TABLE clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_clientes_telefone UNIQUE (telefone),
    CONSTRAINT uq_clientes_email UNIQUE (email)
);

CREATE TABLE aparelhos (
    id_aparelho INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(80) NOT NULL,
    imei VARCHAR(20),
    cor VARCHAR(40),
    observacoes VARCHAR(255),
    CONSTRAINT uq_aparelhos_imei UNIQUE (imei),
    CONSTRAINT fk_aparelhos_clientes FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE tecnicos (
    id_tecnico INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    especialidade VARCHAR(100),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE ordens_servico (
    id_os INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT UNSIGNED NOT NULL,
    id_aparelho INT UNSIGNED NOT NULL,
    id_tecnico INT UNSIGNED,
    defeito_relatado TEXT NOT NULL,
    diagnostico TEXT,
    status ENUM('ABERTA', 'EM_ANALISE', 'AGUARDANDO_APROVACAO',
                'AGUARDANDO_PECA', 'EM_REPARO', 'CONCLUIDA',
                'ENTREGUE', 'CANCELADA') NOT NULL DEFAULT 'ABERTA',
    prioridade ENUM('BAIXA', 'NORMAL', 'ALTA', 'URGENTE') NOT NULL DEFAULT 'NORMAL',
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    prazo_estimado DATETIME,
    data_conclusao DATETIME,
    data_entrega DATETIME,
    observacoes TEXT,
    CONSTRAINT fk_os_clientes FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_os_aparelhos FOREIGN KEY (id_aparelho)
        REFERENCES aparelhos (id_aparelho) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_os_tecnicos FOREIGN KEY (id_tecnico)
        REFERENCES tecnicos (id_tecnico) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_os_datas CHECK (data_conclusao IS NULL OR data_conclusao >= data_abertura),
    INDEX idx_os_status (status),
    INDEX idx_os_abertura (data_abertura),
    INDEX idx_os_prazo (prazo_estimado)
);

CREATE TABLE servicos (
    id_servico INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco_base DECIMAL(10,2) NOT NULL,
    CONSTRAINT uq_servicos_nome UNIQUE (nome),
    CONSTRAINT ck_servicos_preco CHECK (preco_base >= 0)
);

CREATE TABLE os_servicos (
    id_os INT UNSIGNED NOT NULL,
    id_servico INT UNSIGNED NOT NULL,
    quantidade SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_os_servicos_os FOREIGN KEY (id_os)
        REFERENCES ordens_servico (id_os) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_os_servicos_servicos FOREIGN KEY (id_servico)
        REFERENCES servicos (id_servico) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_os_servicos_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_os_servicos_valor CHECK (valor_unitario >= 0)
);

CREATE TABLE pecas (
    id_peca INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    sku VARCHAR(40) NOT NULL,
    custo_unitario DECIMAL(10,2) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    estoque_atual INT UNSIGNED NOT NULL DEFAULT 0,
    estoque_minimo INT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT uq_pecas_sku UNIQUE (sku),
    CONSTRAINT ck_pecas_custo CHECK (custo_unitario >= 0),
    CONSTRAINT ck_pecas_preco CHECK (preco_venda >= 0)
);

CREATE TABLE os_pecas (
    id_os INT UNSIGNED NOT NULL,
    id_peca INT UNSIGNED NOT NULL,
    quantidade SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_os, id_peca),
    CONSTRAINT fk_os_pecas_os FOREIGN KEY (id_os)
        REFERENCES ordens_servico (id_os) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_os_pecas_pecas FOREIGN KEY (id_peca)
        REFERENCES pecas (id_peca) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_os_pecas_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_os_pecas_valor CHECK (valor_unitario >= 0)
);

CREATE TABLE pagamentos (
    id_pagamento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_os INT UNSIGNED NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('DINHEIRO', 'PIX', 'DEBITO', 'CREDITO', 'BOLETO') NOT NULL,
    status ENUM('PENDENTE', 'PAGO', 'ESTORNADO') NOT NULL DEFAULT 'PENDENTE',
    data_pagamento DATETIME,
    parcelas TINYINT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT fk_pagamentos_os FOREIGN KEY (id_os)
        REFERENCES ordens_servico (id_os) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_pagamentos_valor CHECK (valor > 0),
    CONSTRAINT ck_pagamentos_parcelas CHECK (parcelas BETWEEN 1 AND 24),
    INDEX idx_pagamentos_data (data_pagamento),
    INDEX idx_pagamentos_status (status)
);

