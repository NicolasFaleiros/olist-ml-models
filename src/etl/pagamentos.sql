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
