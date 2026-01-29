-- =========================================
-- QUERIES DE KPIs FINANCEIROS
-- Projeto: BI-Financeiro-Crescimento
-- Autor: Guilherme de Almeida Campos
-- Data: Janeiro 2026
-- =========================================

-- ===========================================
-- 1. RECEITA TOTAL POR PER\u00cdODO
-- ===========================================
SELECT 
    YEAR(data_venda) AS ano,
    MONTH(data_venda) AS mes,
    SUM(valor_total) AS receita_total,
    COUNT(DISTINCT id_pedido) AS total_pedidos,
    ROUND(SUM(valor_total) / COUNT(DISTINCT id_pedido), 2) AS ticket_medio
FROM 
    vendas
WHERE 
    data_venda >= DATEADD(MONTH, -12, GETDATE())
GROUP BY 
    YEAR(data_venda), 
    MONTH(data_venda)
ORDER BY 
    ano DESC, 
    mes DESC;

-- ===========================================
-- 2. MARGEM BRUTA E L\u00cdQUIDA
-- ===========================================
SELECT 
    YEAR(v.data_venda) AS ano,
    MONTH(v.data_venda) AS mes,
    SUM(v.valor_total) AS receita,
    SUM(c.custo_produto) AS custo_produtos,
    SUM(c.custo_operacional) AS custo_operacional,
    -- Margem Bruta
    SUM(v.valor_total) - SUM(c.custo_produto) AS margem_bruta_valor,
    ROUND(((SUM(v.valor_total) - SUM(c.custo_produto)) / NULLIF(SUM(v.valor_total), 0)) * 100, 2) AS margem_bruta_percentual,
    -- Margem L\u00edquida
    SUM(v.valor_total) - SUM(c.custo_produto) - SUM(c.custo_operacional) AS margem_liquida_valor,
    ROUND(((SUM(v.valor_total) - SUM(c.custo_produto) - SUM(c.custo_operacional)) / NULLIF(SUM(v.valor_total), 0)) * 100, 2) AS margem_liquida_percentual
FROM 
    vendas v
LEFT JOIN 
    custos c ON v.id_pedido = c.id_pedido
WHERE 
    v.data_venda >= DATEADD(YEAR, -1, GETDATE())
GROUP BY 
    YEAR(v.data_venda), 
    MONTH(v.data_venda)
ORDER BY 
    ano DESC, 
    mes DESC;

-- ===========================================
-- 3. CRESCIMENTO YoY (Year over Year)
-- ===========================================
WITH ReceitaMensal AS (
    SELECT 
        YEAR(data_venda) AS ano,
        MONTH(data_venda) AS mes,
        SUM(valor_total) AS receita_total
    FROM 
        vendas
    WHERE 
        data_venda >= DATEADD(YEAR, -2, GETDATE())
    GROUP BY 
        YEAR(data_venda), 
        MONTH(data_venda)
)
SELECT 
    a.ano AS ano_atual,
    a.mes,
    a.receita_total AS receita_atual,
    b.receita_total AS receita_ano_anterior,
    a.receita_total - b.receita_total AS diferenca,
    ROUND(((a.receita_total - b.receita_total) / NULLIF(b.receita_total, 0)) * 100, 2) AS crescimento_yoy_percentual
FROM 
    ReceitaMensal a
LEFT JOIN 
    ReceitaMensal b ON a.mes = b.mes AND a.ano = b.ano + 1
WHERE 
    b.receita_total IS NOT NULL
ORDER BY 
    a.ano DESC, 
    a.mes DESC;

-- ===========================================
-- 4. FLUXO DE CAIXA DI\u00c1RIO
-- ===========================================
SELECT 
    CAST(data_movimento AS DATE) AS data,
    SUM(CASE WHEN tipo_movimento = 'ENTRADA' THEN valor ELSE 0 END) AS total_entradas,
    SUM(CASE WHEN tipo_movimento = 'SAIDA' THEN valor ELSE 0 END) AS total_saidas,
    SUM(CASE WHEN tipo_movimento = 'ENTRADA' THEN valor ELSE -valor END) AS saldo_dia,
    SUM(SUM(CASE WHEN tipo_movimento = 'ENTRADA' THEN valor ELSE -valor END)) 
        OVER (ORDER BY CAST(data_movimento AS DATE)) AS saldo_acumulado
FROM 
    fluxo_caixa
WHERE 
    data_movimento >= DATEADD(MONTH, -3, GETDATE())
GROUP BY 
    CAST(data_movimento AS DATE)
ORDER BY 
    data DESC;

-- ===========================================
-- 5. ROI (Return on Investment)
-- ===========================================
SELECT 
    categoria_investimento,
    SUM(valor_investido) AS total_investido,
    SUM(retorno_obtido) AS total_retorno,
    SUM(retorno_obtido) - SUM(valor_investido) AS lucro,
    ROUND(((SUM(retorno_obtido) - SUM(valor_investido)) / NULLIF(SUM(valor_investido), 0)) * 100, 2) AS roi_percentual,
    ROUND(AVG(DATEDIFF(DAY, data_investimento, data_retorno)), 0) AS tempo_medio_retorno_dias
FROM 
    investimentos
WHERE 
    status = 'CONCLUIDO'
GROUP BY 
    categoria_investimento
ORDER BY 
    roi_percentual DESC;

-- ===========================================
-- 6. TOP 10 PRODUTOS POR RECEITA
-- ===========================================
SELECT TOP 10
    p.id_produto,
    p.nome_produto,
    p.categoria,
    COUNT(DISTINCT v.id_pedido) AS qtd_vendas,
    SUM(v.quantidade) AS qtd_total_vendida,
    SUM(v.valor_total) AS receita_total,
    ROUND(AVG(v.valor_unitario), 2) AS preco_medio,
    ROUND((SUM(v.valor_total) / SUM(SUM(v.valor_total)) OVER ()) * 100, 2) AS percentual_receita_total
FROM 
    vendas v
INNER JOIN 
    produtos p ON v.id_produto = p.id_produto
WHERE 
    v.data_venda >= DATEADD(MONTH, -6, GETDATE())
GROUP BY 
    p.id_produto,
    p.nome_produto,
    p.categoria
ORDER BY 
    receita_total DESC;

-- ===========================================
-- 7. AN\u00c1LISE DE CUSTOS POR CATEGORIA
-- ===========================================
SELECT 
    categoria_custo,
    YEAR(data_custo) AS ano,
    MONTH(data_custo) AS mes,
    COUNT(*) AS quantidade_lancamentos,
    SUM(valor) AS total_custo,
    ROUND(AVG(valor), 2) AS custo_medio,
    ROUND((SUM(valor) / SUM(SUM(valor)) OVER (PARTITION BY YEAR(data_custo), MONTH(data_custo))) * 100, 2) AS percentual_total_mes
FROM 
    custos_detalhados
WHERE 
    data_custo >= DATEADD(YEAR, -1, GETDATE())
GROUP BY 
    categoria_custo,
    YEAR(data_custo),
    MONTH(data_custo)
ORDER BY 
    ano DESC,
    mes DESC,
    total_custo DESC;

-- ===========================================
-- 8. PREVIS\u00c3O DE RECEITA (M\u00c9DIA M\u00d3VEL 3 MESES)
-- ===========================================
WITH ReceitaMensal AS (
    SELECT 
        YEAR(data_venda) AS ano,
        MONTH(data_venda) AS mes,
        SUM(valor_total) AS receita_mensal
    FROM 
        vendas
    GROUP BY 
        YEAR(data_venda),
        MONTH(data_venda)
)
SELECT 
    ano,
    mes,
    receita_mensal,
    ROUND(AVG(receita_mensal) OVER (ORDER BY ano, mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS media_movel_3_meses,
    ROUND(AVG(receita_mensal) OVER (ORDER BY ano, mes ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 2) AS media_movel_6_meses
FROM 
    ReceitaMensal
ORDER BY 
    ano DESC,
    mes DESC;

-- ===========================================
-- 9. DASHBOARD EXECUTIVO - VIS\u00c3O GERAL
-- ===========================================
SELECT 
    -- Receita
    (SELECT SUM(valor_total) FROM vendas WHERE MONTH(data_venda) = MONTH(GETDATE()) AND YEAR(data_venda) = YEAR(GETDATE())) AS receita_mes_atual,
    (SELECT SUM(valor_total) FROM vendas WHERE MONTH(data_venda) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND YEAR(data_venda) = YEAR(DATEADD(MONTH, -1, GETDATE()))) AS receita_mes_anterior,
    
    -- Custos
    (SELECT SUM(valor) FROM custos_detalhados WHERE MONTH(data_custo) = MONTH(GETDATE()) AND YEAR(data_custo) = YEAR(GETDATE())) AS custos_mes_atual,
    
    -- Fluxo de Caixa
    (SELECT SUM(CASE WHEN tipo_movimento = 'ENTRADA' THEN valor ELSE -valor END) FROM fluxo_caixa WHERE CAST(data_movimento AS DATE) = CAST(GETDATE() AS DATE)) AS saldo_hoje,
    
    -- Total de Pedidos
    (SELECT COUNT(*) FROM vendas WHERE MONTH(data_venda) = MONTH(GETDATE()) AND YEAR(data_venda) = YEAR(GETDATE())) AS pedidos_mes_atual,
    
    -- Ticket M\u00e9dio
    (SELECT ROUND(AVG(valor_total), 2) FROM vendas WHERE MONTH(data_venda) = MONTH(GETDATE()) AND YEAR(data_venda) = YEAR(GETDATE())) AS ticket_medio_mes;

-- ===========================================
-- 10. AN\u00c1LISE DE REGI\u00c3O GEOGR\u00c1FICA
-- ===========================================
SELECT 
    r.regiao,
    r.estado,
    COUNT(DISTINCT v.id_pedido) AS total_pedidos,
    SUM(v.valor_total) AS receita_total,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio,
    ROUND((SUM(v.valor_total) / SUM(SUM(v.valor_total)) OVER ()) * 100, 2) AS percentual_receita_total,
    COUNT(DISTINCT v.id_cliente) AS clientes_unicos
FROM 
    vendas v
INNER JOIN 
    clientes c ON v.id_cliente = c.id_cliente
INNER JOIN 
    regioes r ON c.id_regiao = r.id_regiao
WHERE 
    v.data_venda >= DATEADD(YEAR, -1, GETDATE())
GROUP BY 
    r.regiao,
    r.estado
ORDER BY 
    receita_total DESC;

-- =========================================
-- FIM DO ARQUIVO
-- =========================================
