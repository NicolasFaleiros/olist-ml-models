WITH tb_pedido AS ( 
    SELECT 
        t1.idPedido,
        t2.idVendedor,
        t1.dtPedido,
        t1.descSituacao,
        t1.dtAprovado,
        t1.dtEntregue,
        t1.dtEstimativaEntrega,
        SUM(vlFrete) AS totalFrete

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND t2.idVendedor IS NOT NULL

    GROUP BY 
        t1.idPedido,
        t2.idVendedor,
        t1.dtPedido,
        t1.dtAprovado,
        t1.dtEntregue,
        t1.dtEstimativaEntrega
)

SELECT
    idVendedor,
    CAST(COUNT(DISTINCT CASE WHEN DATE(COALESCE(dtEntregue, '2018-01-01')) > DATE(dtEstimativaEntrega) THEN idPedido END) AS FLOAT) / COUNT(DISTINCT CASE WHEN descSituacao = 'delivered' THEN idPedido END) AS pctPedidoAtraso,
    CAST(COUNT(DISTINCT CASE WHEN descSituacao = 'canceled' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoCancelado,
    AVG(totalFrete) as avgFrete,
    MAX(totalFrete) as maxFrete,
    MIN(totalFrete) as minFrete,
    AVG(julianday(DATE(COALESCE(dtEntregue, '2018-01-01'))) - julianday(DATE(dtPedido))) AS avgDiasPedidoEntrega,
    AVG(julianday(DATE(COALESCE(dtEntregue, '2018-01-01'))) - julianday(DATE(dtAprovado))) AS avgDiasAprovadoEntrega,
    AVG(julianday(DATE(dtEstimativaEntrega)) - julianday(DATE(COALESCE(dtEntregue, '2018-01-01')))) AS avgDiasPromessaEntrega -- Valores negativos indicam a quantidade, em média, de dias que o vendedor atrasou a entrega do pedido referente à estimativa de entrega fornecida

FROM tb_pedido

GROUP BY 1;