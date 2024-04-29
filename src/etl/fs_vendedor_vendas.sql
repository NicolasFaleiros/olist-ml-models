-- Active: 1714187815517@@127.0.0.1@3306
WITH tb_pedido_item As(
    SELECT 
        t2.*,
        t1.dtPedido

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '{date}'
    AND t1.dtPedido >= DATE('{date}','-6 MONTH')
    AND t2.idVendedor IS NOT NULL
),

tb_summary AS (
    SELECT
        idVendedor,
        COUNT(DISTINCT idPedido) AS qtdePedidos,
        COUNT(DISTINCT DATE(dtPedido)) AS qtdeDias,
        COUNT(idProduto) AS qtdeItens,
        MIN(julianday('{date}') - julianday(dtPedido)) AS qtdeRecencia,
        SUM(vlPreco) / COUNT(DISTINCT idPedido) AS avgTicket,
        AVG(vlPreco) AS avgValorProduto,
        MAX(vlPreco) AS maxValorProduto,
        MIN(vlPreco) AS minValorProduto,
        COUNT(idProduto) / COUNT(DISTINCT idPedido) AS avgProdutoPedido

    FROM tb_pedido_item

    GROUP BY idVendedor
),

tb_pedido_summary AS (
    SELECT
        idVendedor,
        idPedido,
        SUM(vlPreco) AS vlPreco

    FROM tb_pedido_item

    GROUP BY idVendedor, idPedido
),

tb_min_max AS (
    SELECT 
        idVendedor,
        AVG(vlPreco) AS avgVlPedido,
        MIN(vlPreco) AS minVlPedido,
        MAX(vlPreco) AS maxVlPedido

    FROM tb_pedido_summary

    GROUP BY idVendedor
),

tb_life AS (
    SELECT 
        t2.idVendedor,
        SUM(vlPreco) AS LTV,
        MAX(julianday('{date}') - julianday(DATE(dtPedido))) AS qtdeDiasBase

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '{date}'
    AND t2.idVendedor IS NOT NULL

    GROUP BY 1
),

tb_dtpedido AS (
    SELECT
        idVendedor,
        DATE(dtPedido) AS dtPedido

    FROM tb_pedido_item

    ORDER BY 1,2
),

tb_lag AS (
    SELECT
        *,
        LAG(dtPedido) OVER (PARTITION BY idVendedor ORDER BY dtPedido) AS lag1

    FROM tb_dtpedido
),

tb_intervalo AS (
    SELECT
        idVendedor,
        AVG(julianday(DATE(dtPedido)) - julianday(DATE(lag1))) AS avgIntervaloVendas

    FROM tb_lag

    GROUP BY idVendedor
)

SELECT
    '{date}' AS dtReference,
    t1.*,
    t2.minVlPedido,
    t2.maxVlPedido,
    t3.LTV,
    t3.qtdeDiasBase,
    t4.avgIntervaloVendas

FROM tb_summary AS t1

LEFT JOIN tb_min_max AS t2
ON t1.idVendedor = t2.idVendedor

LEFT JOIN tb_life AS t3
ON t1.idVendedor = t3.idVendedor

LEFT JOIN tb_intervalo AS t4
ON t1.idVendedor = t4.idVendedor;