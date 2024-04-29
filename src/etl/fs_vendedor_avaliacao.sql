WITH tb_pedido AS (
    SELECT
        DISTINCT 
        t1.idPedido,
        t2.idVendedor

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '{date}'
    AND t1.dtPedido >= DATE('{date}','-6 MONTH')
    AND idVendedor IS NOT NULL
),

tb_join AS (
    SELECT
        t1.*,
        t2.*

    FROM tb_pedido AS t1

    LEFT JOIN avaliacao_pedido AS t2
    ON t1.idPedido = t2.idPedido
),

tb_summary AS (
    SELECT
        idVendedor,
        AVG(vlNota) as avgNota,
        MAX(vlNota) as maxNota,
        MIN(vlNota) as minNota,
        COUNT(vlNota) / COUNT(idPedido) as pctAvaliacao

    FROM tb_join

    GROUP BY idVendedor
)

SELECT
    '{date}' AS dtReference,
    DATE('now') AS dtIngestion,
    *

FROM tb_summary;