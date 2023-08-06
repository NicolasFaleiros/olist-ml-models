WITH tb_join AS (
    SELECT 
        DISTINCT
        t1.idPedido,
        t1.idCliente,
        t2.idVendedor,
        t3.descUF

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    LEFT JOIN cliente AS t3
    ON t1.idCliente = t3.idCliente

    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND idVendedor IS NOT NULL
),

tb_group AS (
        SELECT 
        idVendedor,
        COUNT(DISTINCT descUF) as qtdeUFsPedidos,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'AC' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoAC,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'AL' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoAL,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'AM' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoAM,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'AP' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoAP,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'BA' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoBA,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'CE' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoCE,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'DF' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoDF,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'ES' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoES,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'GO' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoGO,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'MA' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoMA,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'MG' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoMG,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'MS' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoMS,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'MT' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoMT,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'PA' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoPA,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'PB' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoPB,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'PE' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoPE,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'PI' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoPI,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'PR' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoPR,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'RJ' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoRJ,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'RN' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoRN,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'RO' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoRO,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'RR' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoRR,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'RS' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoRS,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'SC' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoSC,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'SE' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoSE,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'SP' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoSP,
        CAST(COUNT(DISTINCT CASE WHEN descUF = 'TO' THEN idPedido END) AS FLOAT) / COUNT(DISTINCT idPedido) as pctPedidoTO

    FROM tb_join
    GROUP BY idVendedor
)

SELECT
    '2018-01-01' AS dtReference,
    *
FROM tb_group;