
-- CONSULTA DE BANCO DE DADOS PARA PROJETO OEE / SUPORTE MES

-- 1. Criação do Banco de Dados
CREATE DATABASE MES_Prodwin_Teste;
GO

-- 2. Seleciona o Banco
USE MES_Prodwin_Teste;
GO

-- 3. Limpa Tabelas Antigas
DROP TABLE IF EXISTS Paradas;
DROP TABLE IF EXISTS Producoes;
DROP TABLE IF EXISTS Maquinas;
GO

-- 4. TABELAS
CREATE TABLE Maquinas (
    id_maquina INT PRIMARY KEY,
    nome_maquina NVARCHAR(50),
    setor NVARCHAR(50)
);

CREATE TABLE Producoes (
    id_producao INT PRIMARY KEY IDENTITY(1,1),
    id_maquina INT FOREIGN KEY REFERENCES Maquinas(id_maquina),
    data_producao DATE,
    turno NVARCHAR(1),
    tempo_operacao_seg INT,
    tempo_disponivel_seg INT,
    tempo_ciclo_real_seg INT,
    tempo_ciclo_padrao_seg INT,
    produtos_bons INT,
    produtos_descartados INT
);

CREATE TABLE Paradas (
    id_parada INT PRIMARY KEY IDENTITY(1,1),
    id_producao INT FOREIGN KEY REFERENCES Producoes(id_producao),
    data_hora_inicio DATETIME,
    data_hora_fim DATETIME,
    tipo NVARCHAR(50),
    motivo NVARCHAR(100),
    duracao_seg INT
);

-- 5. INSERÇÃO DOS DADOS

INSERT INTO Maquinas (id_maquina, nome_maquina, setor)
VALUES
(1, 'Prensa 01', 'Estamparia'),
(2, 'Torno 02', 'Usinagem'),
(3, 'Injetora 03', 'Plásticos'),
(4, 'Fresadora 04', 'Usinagem');

-- Produções
INSERT INTO Producoes (id_maquina, data_producao, turno, tempo_operacao_seg, tempo_disponivel_seg, tempo_ciclo_real_seg, tempo_ciclo_padrao_seg, produtos_bons, produtos_descartados)
VALUES
-- Maquina 1 - estável 
(1, '2027-10-30', 'A', 27000, 28800, 45, 40, 750, 30),
-- Maquina 2 - normal
(2, '2027-10-30', 'B', 25200, 28800, 50, 45, 680, 40),
-- Maquina 3 - problemas
(3, '2027-10-30', 'C', 21600, 28800, 60, 50, 450, 120),
(3, '2027-10-31', 'C', 24000, 28800, 58, 50, 470, 80),
-- Maquina 4 - alta qualidade
(4, '2027-10-30', 'A', 28000, 28800, 42, 38, 820, 20);

-- Paradas 
INSERT INTO Paradas (id_producao, data_hora_inicio, data_hora_fim, tipo, motivo, duracao_seg)
VALUES
(1, '2027-10-30T09:00:00', '2027-10-30T10:00:00', 'Planejada', 'Setup', 3600),
(1, '2027-10-30T14:00:00', '2027-10-30T14:20:00', 'Não Planejada', 'Ajuste de Ferramenta', 1200),

(2, '2027-10-30T11:00:00', '2027-10-30T12:00:00', 'Planejada', 'Troca de Ferramenta', 3600),
(2, '2027-10-30T16:00:00', '2027-10-30T16:30:00', 'Não Planejada', NULL, 1800),

(3, '2027-10-30T08:30:00', '2027-10-30T09:15:00', 'Não Planejada', 'Falha Elétrica', 2700),
(3, '2027-10-30T13:00:00', '2027-10-30T14:30:00', 'Planejada', 'Setup', 5400),
(3, '2027-10-30T19:00:00', '2027-10-30T19:45:00', 'Não Planejada', NULL, 2700),

(4, '2027-10-30T15:00:00', '2027-10-30T15:40:00', 'Planejada', 'Limpeza de Máquina', 2400);

-- 6.Cálculo do OEE
SELECT
    M.nome_maquina,
    P.data_producao,
    P.turno,
    
    -- DISPONIBILIDADE
    CAST(P.tempo_operacao_seg AS FLOAT) / P.tempo_disponivel_seg AS Disponibilidade,
    
    -- PERFORMANCE
    (CAST(P.tempo_ciclo_padrao_seg AS FLOAT) / P.tempo_ciclo_real_seg) AS Performance,
    
    -- QUALIDADE
    CAST(P.produtos_bons AS FLOAT) /
    (P.produtos_bons + P.produtos_descartados) AS Qualidade,
    
    -- OEE FINAL
    (CAST(P.tempo_operacao_seg AS FLOAT) / P.tempo_disponivel_seg) *
    ((CAST(P.tempo_ciclo_padrao_seg AS FLOAT) / P.tempo_ciclo_real_seg)) *
    (CAST(P.produtos_bons AS FLOAT) /
    (P.produtos_bons + P.produtos_descartados)) AS OEE

FROM Producoes P
JOIN Maquinas M ON P.id_maquina = M.id_maquina
ORDER BY P.data_producao, M.nome_maquina;
GO

-- 7. AUDITORIA: Diagnóstico de Paradas Não Planejadas
SELECT
    M.nome_maquina,
    COUNT(P.id_parada) AS qtd_paradas, 
    SUM(DATEDIFF(SECOND, P.data_hora_inicio, P.data_hora_fim)) / 60 AS minutos_parado,
    SUM(CASE WHEN P.motivo IS NULL THEN 1 ELSE 0 END) AS paradas_sem_motivo
FROM Paradas P
JOIN Producoes PR ON P.id_producao = PR.id_producao
JOIN Maquinas M ON PR.id_maquina = M.id_maquina
WHERE P.tipo = 'Não Planejada'
GROUP BY M.nome_maquina;
GO
