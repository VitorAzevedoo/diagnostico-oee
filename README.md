🏭 Diagnóstico OEE – Máquina 3 (Sistema MES Prodwin)
📌 Situação

Um cliente industrial procurou o suporte técnico relatando que a Máquina 3 estava com queda de produtividade nas últimas semanas, suspeitando que o problema poderia estar no sistema MES.
Além disso, solicitou apoio para entender a origem da falha.

Com base nisso, realizei uma análise de dados (criando dados fictícios) utilizando SQL e visualizando no Power BI, aplicando a fórmula de OEE (Overall Equipment Effectiveness) para confirmar a eficiência produtiva geral e comparar com a Máquina 3.

🧩 Estrutura de Dados (Banco de Teste)

Foi criado um banco simulado (MES_Prodwin_Teste) representando um ambiente real de produção com as tabelas:

Maquinas

Producoes

Paradas

Foram incluídos dados de quatro máquinas: Prensa 01, Torno 02, Injetora 03 e Fresadora 04, sendo a Injetora 03 o foco da análise por apresentar desempenho inferior.

🧮 Consultas SQL Aplicadas

As consultas mediram os três componentes do OEE:

Disponibilidade: tempo_operacao / tempo_disponivel

Performance: tempo_ciclo_padrao / tempo_ciclo_real

Qualidade: produtos_bons / (produtos_bons + retrabalhos + descartados)

OEE = Disponibilidade × Performance × Qualidade

Também foram geradas consultas para:

Total de paradas não planejadas

Quantidade de paradas sem motivo registrado

Esses dados foram integrados ao Power BI para análise visual.

📊 Dashboard no Power BI

O painel foi desenvolvido em layout escuro e limpo, dividido em quatro seções principais:

1️⃣ KPIs Globais da Fábrica
Indicadores de OEE geral (~69,99%), Disponibilidade, Performance e Qualidade.
A cor de destaque foi aplicada em Disponibilidade, evidenciando o ponto crítico.

2️⃣ OEE por Máquina
Gráfico de barras comparando a eficiência das máquinas.
A Máquina 3 apresenta o menor OEE, confirmando o problema relatado.

3️⃣ Paradas Não Planejadas – Causa Raiz
Gráfico de pizza mostrando a proporção de motivos de parada.
A fatia “Sem motivo” (em branco) evidencia falhas de registro no chão de fábrica.

4️⃣ Tempo Total Parado por Máquina
Gráfico de barras comparando o tempo parado da Máquina 3 com a Máquina 01.
Resultado: a Máquina 3 ficou mais que o dobro do tempo parada em relação à Prensa 01.

⚙️ Fórmulas criadas no Power BI (DAX)
Disponibilidade = DIVIDE(SUM(Producoes[tempo_operacao]), SUM(Producoes[tempo_disponivel]))
Performance = DIVIDE(SUM(Producoes[tempo_ciclo_padrao]), SUM(Producoes[tempo_ciclo_real]))
Qualidade = DIVIDE(SUM(Producoes[produtos_bons]), SUM(Producoes[produtos_bons]) + SUM(Producoes[produtos_descartados]))
OEE = [Disponibilidade] * [Performance] * [Qualidade]


Essas medidas foram aplicadas aos KPIs superiores, garantindo consistência entre SQL e Power BI.

📈 Interpretação dos Resultados

A análise comprovou que o sistema MES Prodwin está operando normalmente.
O problema de desempenho da Máquina 3 está ligado a falhas operacionais:

Paradas não registradas corretamente;

Queda de disponibilidade;

Retrabalho acima da média.

Esses fatores explicam o baixo OEE e reforçam que o gargalo está no processo, não no sistema.

🛠️ Recomendações Técnicas e Operacionais

Refletir a importância de registrar corretamente o motivo das paradas.
Dados incompletos distorcem relatórios e diagnósticos.

Configurar o sistema MES para obrigar o preenchimento do motivo de parada antes de salvar o registro, evitando lacunas.
