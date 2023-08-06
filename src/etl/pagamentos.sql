SELECT * 
FROM pedido 
WHERE dtPedido < '2018-01-01'
 AND dtPedido >= DATE('2018-01-01','-6 MONTH');


WITH tb_join AS (
    SELECT  t2.*,
            t3.idVendedor
    FROM pedido AS t1

    LEFT JOIN pagamento_pedido AS t2
    ON t1.idPedido = t2.idPedido

    LEFT JOIN item_pedido AS t3
    ON t1.idPedido = t3.idPedido

    WHERE dtPedido < '2018-01-01'
    AND dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND t3.idVendedor IS NOT NULL
),

tb_group AS (

    SELECT  idVendedor,
            descTipoPagamento,
            COUNT(DISTINCT idPedido) AS qtdePedidoMeioPagamento,
            sum(vlPagamento) AS vlPedidoMeioPagamento
    FROM tb_join
    GROUP BY idVendedor, descTipoPagamento
    ORDER BY idVendedor, descTipoPagamento
)

SELECT  idVendedor,
        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_voucher_pedido,

        CAST(SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_credit_card_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_boleto_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_debit_card_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_voucher_pedido,
                
        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_voucher_pedido,

        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_voucher_pedido

FROM tb_group
GROUP BY 1;

-- Para evitar duplicidade do idPedido, precisamos preparar os dados antes de rodar o SELECT anterior

WITH tb_pedidos AS (
    SELECT  
        DISTINCT 
        t1.idPedido,
        t1.dtPedido,
        t2.idVendedor
    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND idVendedor IS NOT NULL
),

tb_join AS (
    SELECT  t1.idVendedor,
            t2.*
    FROM tb_pedidos AS t1

    LEFT JOIN pagamento_pedido AS t2
    ON t1.idPedido = t2.idPedido

    LEFT JOIN item_pedido AS t3
    ON t1.idPedido = t3.idPedido

    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND t1.idVendedor IS NOT NULL
),

tb_group AS (

    SELECT  idVendedor,
            descTipoPagamento,
            COUNT(DISTINCT idPedido) AS qtdePedidoMeioPagamento,
            sum(vlPagamento) AS vlPedidoMeioPagamento
    FROM tb_join
    GROUP BY idVendedor, descTipoPagamento
    ORDER BY idVendedor, descTipoPagamento
),
-- Aqui obtemos o percentual de cada tipo de pagamento, em termos de quantidade e valor
tb_summary AS(
    SELECT  idVendedor,
        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_voucher_pedido,

        CAST(SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_credit_card_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_boleto_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_debit_card_pedido,
        CAST(SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN qtdePedidoMeioPagamento ELSE 0 END) AS FLOAT) / SUM(qtdePedidoMeioPagamento) AS pct_qtde_voucher_pedido,
                
        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_voucher_pedido,

        SUM(CASE WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_credit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'boleto'      THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_boleto_pedido,
        SUM(CASE WHEN descTipoPagamento = 'debit_card'  THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_debit_card_pedido,
        SUM(CASE WHEN descTipoPagamento = 'voucher'     THEN vlPedidoMeioPagamento ELSE 0 END) / SUM(vlPedidoMeioPagamento) AS pct_valor_voucher_pedido

    FROM tb_group
    GROUP BY idVendedor
),
-- Aqui obtemos a quantidade média de parcelas, quando o método de pagamento é cartão
tb_cartao AS (
    SELECT 
        idVendedor,
        AVG(nrParcelas) AS avgQtdeParcelas,
        MAX(nrParcelas) AS maxQtdeParcelas,
        MIN(nrParcelas) AS minQtdeParcelas
    FROM tb_join
    WHERE descTipoPagamento = 'credit_card'
    GROUP BY idVendedor
)

SELECT 
    '2018-01-01' AS dtReference,
    t1.*,
    t2.avgQtdeParcelas,
    t2.maxQtdeParcelas,
    t2.minQtdeParcelas
FROM tb_summary AS t1

LEFT JOIN tb_cartao as t2
ON t1.idVendedor = t2.idVendedor;