# 📊 BI-Financeiro-Crescimento

> Dashboard de Business Intelligence para análise financeira e estratégia de crescimento empresarial

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Contributors](https://img.shields.io/badge/contributors-1-blue)]()
[![Last Commit](https://img.shields.io/github/last-commit/intergac/BI-Financeiro-Crescimento)](#)

---

## 🎯 Visão Geral

O **BI-Financeiro-Crescimento** é um projeto de Business Intelligence desenvolvido para empresas que buscam otimizar sua gestão financeira e acelerar seu crescimento. Com dashboards interativos e análises profundas, este projeto oferece visibilidade total sobre:

- 💰 **Análise de Receitas** - Receita por período, produto e região
- 📉 **Controle de Custos** - Categorização e análise de despesas
- 📊 **Margens de Lucro** - KPIs de rentabilidade e eficiência
- 💵 **Fluxo de Caixa** - Previsão e controle de liquidez
- 🎯 **KPIs Estratégicos** - Indicadores-chave para tomada de decisão
- 📈 **Análise de Crescimento** - Tendências e projeções

---

## 🚀 Ferramentas e Tecnologias

### Principais Plataformas

- **Power BI** - Dashboards interativos e visualizações
- **Tableau** - Análises avançadas e storytelling de dados
- **SQL Server / MySQL** - Banco de dados e queries otimizadas
- **Python** - Processamento de dados e automação
- **Excel** - Modelos financeiros e cálculos

### Ferramentas Suporte

```
├── Data Integration
│   ├── Power Query (ETL)
│   ├── Python (Pandas, NumPy)
│   └── SQL Scripts
│
├── Analytics & Visualization
│   ├── Power BI Desktop
│   ├── Tableau Public
│   └── Python (Matplotlib, Plotly)
│
└── Documentation
    ├── README.md
    ├── SQL_Queries.md
    └── Dashboard_Guide.md
```

---

## 📁 Estrutura do Projeto

```
BI-Financeiro-Crescimento/
├── 📂 data/
│   ├── raw/                      # Dados brutos originais
│   │   ├── receitas_2024.csv
│   │   ├── custos_2024.csv
│   │   └── movimentacao_caixa.xlsx
│   │
│   └── processed/                # Dados processados e limpos
│       ├── receitas_tratado.csv
│       └── custos_tratado.csv
│
├── 📂 sql/
│   ├── CREATE_TABLES.sql         # Scripts de criação
│   ├── LOAD_DATA.sql             # Carregamento de dados
│   ├── KPI_QUERIES.sql           # Queries para KPIs
│   └── ANALYSIS_QUERIES.sql      # Análises avançadas
│
├── 📂 dashboards/
│   ├── Dashboard_Executivo.pbix  # Power BI - Visão executiva
│   ├── Dashboard_Detalhado.pbix  # Power BI - Análise profunda
│   └── Dashboard_Crescimento.pbix # Power BI - Estratégia de crescimento
│
├── 📂 python/
│   ├── data_processing.py        # Limpeza e transformação
│   ├── kpi_calculator.py         # Cálculo de indicadores
│   └── automation.py             # Automação de processos
│
├── 📂 documentation/
│   ├── README.md                 # Este arquivo
│   ├── SETUP_GUIDE.md            # Guia de instalação
│   ├── SQL_GUIDE.md              # Documentação SQL
│   └── DASHBOARD_GUIDE.md        # Guia dos dashboards
│
└── 📂 templates/
    ├── Modelo_Receitas.xlsx      # Template para entrada de dados
    ├── Modelo_Custos.xlsx        # Template para custos
    └── Modelo_Projecao.xlsx      # Template para projeções
```

---

## 📊 KPIs Principais

| KPI | Descrição | Alvo | Frequência |
|-----|-----------|------|------------|
| **Receita Total** | Soma de todas as receitas | Planejado | Diária |
| **Crescimento YoY** | Crescimento ano a ano | 20% | Mensal |
| **Margem Bruta** | (Receita - COGS) / Receita | >40% | Mensal |
| **Margem Líquida** | Lucro Líquido / Receita | >15% | Mensal |
| **ROI** | Retorno sobre investimento | >25% | Trimestral |
| **Ticket Médio** | Receita / Quantidade de pedidos | Planejado | Diária |
| **Fluxo de Caixa** | Entradas - Saídas | Positivo | Diária |
| **Payback** | Tempo de retorno do investimento | <12 meses | Trimestral |

---

## 🔧 Instalação e Configuração

### Pré-requisitos

- Python 3.8+
- SQL Server ou MySQL
- Power BI Desktop (opcional para visualizações)
- Git

### Passos de Instalação

#### 1. Clonar o repositório

```bash
git clone https://github.com/intergac/BI-Financeiro-Crescimento.git
cd BI-Financeiro-Crescimento
```

#### 2. Configurar banco de dados

```bash
# Criar banco de dados
sqlcmd -S localhost -U sa -P password -i sql/CREATE_TABLES.sql

# Carregar dados iniciais
sqlcmd -S localhost -U sa -P password -i sql/LOAD_DATA.sql
```

#### 3. Instalar dependências Python

```bash
pip install -r requirements.txt
```

#### 4. Executar processamento de dados

```bash
python python/data_processing.py
python python/kpi_calculator.py
```

#### 5. Abrir no Power BI

```
Abra os arquivos .pbix em Power BI Desktop
```

---

## 📈 Como Usar

### Dashboard Executivo
Verwende para:
- Visão geral da saúde financeira
- KPIs críticos
- Tendências rápidas
- Decisões estratégicas

### Dashboard Detalhado
Use para:
- Análise profunda de receitas
- Decomposição de custos
- Análise por período/região/produto
- Investigação de anomalias

### Dashboard de Crescimento
Use para:
- Monitorar progress vs. metas
- Análise de oportunidades
- Projeções futuras
- Simulações de cenários

---

## 💡 Exemplos de Uso

### Query SQL - Receita Mensal

```sql
SELECT 
    YEAR(data_venda) AS ano,
    MONTH(data_venda) AS mes,
    SUM(valor) AS receita_total,
    COUNT(*) AS quantidade_transacoes
FROM tabela_vendas
GROUP BY YEAR(data_venda), MONTH(data_venda)
ORDER BY ano DESC, mes DESC;
```

### Python - Calcular Margem de Lucro

```python
import pandas as pd

df = pd.read_csv('data/processed/vendas_tratado.csv')

df['margem_bruta'] = (df['receita'] - df['custo']) / df['receita'] * 100
df['margem_liquida'] = df['lucro_liquido'] / df['receita'] * 100

print(df[['data', 'margem_bruta', 'margem_liquida']].head(10))
```

---

## 📊 Dados de Exemplo

O projeto inclui dados de amostra para teste:

```
• 3 anos de histórico de receitas
• 500+ categorias de custos
• 10+ regiões geográficas
• 50+ linhas de produto
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Faça um Fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📝 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👨‍💼 Autor

**Guilherme de Almeida Campos**
- 🔗 LinkedIn: [in/intergac](https://www.linkedin.com/in/intergac/)
- 🐙 GitHub: [@intergac](https://github.com/intergac)
- 📧 Email: contato@intergac.com

---

## 📞 Suporte e Contato

Para dúvidas ou sugestões:

- 📌 Abra uma [Issue](../../issues/new) no GitHub
- 💬 Envie uma mensagem via LinkedIn
- 📧 Entre em contato por email

---

## 🎓 Recursos Adicionais

- [Documentação Power BI](https://docs.microsoft.com/pt-br/power-bi/)
- [Tutorial Tableau](https://www.tableau.com/pt-br/learn/training)
- [SQL Server Documentation](https://docs.microsoft.com/pt-br/sql/)
- [Python for Data Science](https://www.python.org/)

---

## 📊 Status do Projeto

- ✅ Estrutura base completa
- ✅ Dashboards Power BI criados
- ✅ Scripts SQL prontos
- 🔄 Em desenvolvimento: Integração com APIs
- 📋 Roadmap: Machine Learning para previsões

---

**Desenvolvido com ❤️ para empresas que buscam crescimento através de dados**
