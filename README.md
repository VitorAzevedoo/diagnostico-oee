# 🏭 Diagnóstico OEE – Máquina 3 (Sistema MES Prodwin)

## 📌 Situação e Objetivo

Um cliente industrial procurou o suporte técnico relatando uma queda de produtividade na Injetora **Máquina 3**, com a suspeita de que o problema poderia estar no sistema MES.

Com base nisso, realizei uma análise completa de dados (criando dados fictícios) utilizando **SQL** para o diagnóstico, e **Power BI** para a visualização, aplicando a fórmula de OEE (Overall Equipment Effectiveness) para confirmar a eficiência produtiva e propor soluções.

## 🔹 Estrutura de Dados (Banco de Teste)

Para a análise, foi criado um banco de teste simulado (`MES_Prodwin_Teste`) que representa a estrutura de um ambiente real de produção com as seguintes tabelas:

* **Maquinas**
* **Producoes**
* **Paradas**

A Injetora 03 foi o foco da análise por apresentar desempenho consistentemente abaixo da média da fábrica.

## 🧮 Consultas SQL Aplicadas (A Origem do Dado)

As consultas foram elaboradas para medir os três **pilares** do OEE, garantindo a precisão dos cálculos na origem:

* **Disponibilidade:** `tempo_operacao / tempo_disponivel`
* **Performance:** `tempo_ciclo_padrao / tempo_ciclo_real`
* **Qualidade:** `produtos_bons / (produtos_bons + retrabalhos + descartados)`

O OEE final foi obtido multiplicando os três fatores:
$$OEE = Disponibilidade \times Performance \times Qualidade$$

**Consultas Críticas Adicionais:**

* Total de paradas não planejadas.
* **Quantidade de paradas sem motivo registrado** (Crucial para o diagnóstico).

Essas informações foram exportadas e integradas ao Power BI.

## 📊 Dashboard no Power BI (A Visualização Estratégica)

O painel foi desenvolvido em um layout limpo e de alto contraste, utilizando o **Laranja/Amarelo** para destacar os alertas:

1️⃣ **KPIs Globais da Fábrica:**
* Exibição do OEE geral (~69,99%), Disponibilidade, Performance e Qualidade.
* O destaque de cor foi aplicado em **Disponibilidade**, indicando o principal ponto de perda.

2️⃣ **OEE por Máquina:**
* Gráfico de barras comparando a eficiência das máquinas.
* A **Máquina 3** apresenta o menor OEE, sendo o gargalo isolado (destacada em Laranja).

3️⃣ **Paradas Não Planejadas – Causa Raiz:**
* Gráfico de colunas/barras empilhadas mostrando a proporção de motivos.
* A fatia **“Sem motivo”** (em Amarelo) evidencia a falha de registro no chão de fábrica.

4️⃣ **Tempo Total Parado por Máquina:**
* Gráfico de contraste comparando o tempo parado da Máquina 3 com a máquina mais produtiva (Prensa 01).
* **Resultado:** A Máquina 3 ficou mais que o dobro do tempo parada (220 minutos) em relação à Prensa 01 (80 minutos).

## ⚙️ Fórmulas Criadas no Power BI (DAX)

As métricas foram replicadas no Power BI para acompanhamento em tempo real:

```dax
Disponibilidade = DIVIDE(SUM(Producoes[tempo_operacao]), SUM(Producoes[tempo_disponivel]))
Performance = DIVIDE(SUM(Producoes[tempo_ciclo_padrao]), SUM(Producoes[tempo_ciclo_real]))
Qualidade = DIVIDE(SUM(Producoes[produtos_bons]), SUM(Producoes[produtos_bons]) + SUM(Producoes[produtos_descartados]))
OEE = [Disponibilidade] * [Performance] * [Qualidade]
