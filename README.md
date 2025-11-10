# 🏭 Diagnóstico OEE – Máquina 3 (Sistema MES Prodwin)

## 📌 SITUAÇÃO

Um cliente industrial procurou o suporte técnico relatando que a Máquina 3 estava com queda de produtividade nas últimas semanas, suspeitando que o problema poderia estar no sistema MES. Além disso, o cliente solicitou apoio para entender a origem da falha.

Com base nisso, realizei uma análise de dados (criando dados fictícios) utilizando SQL e visualizando no Power BI, aplicando a fórmula de OEE (Overall Equipment Effectiveness) para confirmar a eficiência produtiva geral e comparar com a Máquina 3.

## 🧩 ESTRUTURA DE DADOS (BANCO DE TESTE)

Foi criado um banco simulado (`MES_Prodwin_Teste`) representando um ambiente real de produção com as tabelas:

- `Maquinas`
- `Producoes`
- `Paradas`

Foram incluídos dados de quatro máquinas: Prensa 01, Torno 02, Injetora 03 e Fresadora 04, sendo a Injetora 03 o foco da análise por apresentar desempenho inferior.

## 🧮 CONSULTAS SQL 

As consultas mediram os três componentes do OEE:

- **Disponibilidade:** `tempo_operacao / tempo_disponivel`  
- **Performance:** `tempo_ciclo_padrao / tempo_ciclo_real`  
- **Qualidade:** `produtos_bons / (produtos_bons + retrabalhos + descartados)`  

**OEE:** `Disponibilidade × Performance × Qualidade`

Também foram geradas consultas para:

**Total de paradas não planejadas**

**Paradas sem o motivo registrado**  

Esses dados foram integrados ao Power BI para análise visual.

## 📊  Gráficos e Layout

O Layout e dashboard foram desenvolvidos em layout escuro e limpo, dividido em quatro seções principais:

- 1️⃣ **KPIs Globais da Fábrica**  
  Indicadores de OEE geral (~69,99%), Disponibilidade, Performance e Qualidade.  
  A cor de destaque foi aplicada em Disponibilidade, evidenciando o ponto crítico.

- 2️⃣ **OEE por Máquina**  
  Gráfico de barras comparando a eficiência das máquinas.  
  A Máquina 3 apresenta o menor OEE, confirmando o problema relatado.

- 3️⃣ **Paradas Não Planejadas – Causa Raiz**  
  Gráfico de pizza mostrando a proporção de motivos de parada.  
  A fatia “Sem motivo” (em branco) evidencia falhas de registro no chão de fábrica.

- 4️⃣ **Tempo Total Parado por Máquina**  
  Gráfico de barras comparando o tempo parado da Máquina 3 com a Máquina 01.  
  Resultado: a Máquina 3 ficou mais que o dobro do tempo parada em relação à Prensa 01.

## ⚙️ FÓRMULAS CRIADAS NO POWER BI (DAX)

DAX
Disponibilidade = DIVIDE(SUM(Producoes[tempo_operacao]), SUM(Producoes[tempo_disponivel]))
Performance = DIVIDE(SUM(Producoes[tempo_ciclo_padrao]), SUM(Producoes[tempo_ciclo_real]))
Qualidade = DIVIDE(SUM(Producoes[produtos_bons]), SUM(Producoes[produtos_bons]) + SUM(Producoes[produtos_descartados]))
OEE = [Disponibilidade] * [Performance] * [Qualidade]
Essas medidas foram aplicadas aos KPIs superiores, garantindo consistência entre SQL e Power BI.

# 📈 INTERPRETAÇÃO DOS RESULTADOS

A análise comprovou que o sistema MES Prodwin está operando normalmente.
O problema de desempenho da Máquina 3 está relacionado a falhas operacionais, como:

*Paradas não registradas corretamente*

*Queda na disponibilidade*

*Os retrabalhos estão acima da média*

Esses fatores explicam o baixo OEE e reforçam que o problema está no processo, não no sistema.

# 🛠️ RECOMENDAÇÕES TÉCNICAS E OPERACIONAIS

Registrar corretamente o motivo das paradas, porque dados incompletos podem distorcer relatórios e dificultar diagnósticos.

Configurar o sistema MES para obrigar o preenchimento do motivo de parada antes de salvar o registro, evitando esses problemas.
