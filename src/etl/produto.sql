WITH tb_join AS (
    SELECT
        DISTINCT
        t2.idProduto,
        t2.idVendedor,
        t3.*

    FROM pedido AS t1

    LEFT JOIN item_pedido AS t2
    ON t1.idPedido = t2.idPedido

    LEFT JOIN produto AS t3
    ON t2.idProduto = t3.idProduto

    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01','-6 MONTH')
    AND idVendedor IS NOT NULL
),

tb_summary AS (
    SELECT
        idVendedor,
        AVG(COALESCE(nrFotos, 0)) AS avgFotos,
        AVG(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS avgVolumeProduto,
        MAX(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS maxVolumeProduto,
        MIN(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS minVolumeProduto,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'cama_mesa_banho'        THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriacama_mesa_banho,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'beleza_saude'           THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriabeleza_saude,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'esporte_lazer'          THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriaesporte_lazer,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'informatica_acessorios' THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriainformatica_acessorios,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'moveis_decoracao'       THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriamoveis_decoracao,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'utilidades_domesticas'  THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriautilidades_domesticas,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'relogios_presentes'     THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriarelogios_presentes,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'telefonia'              THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriatelefonia,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'automotivo'             THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriaautomotivo,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'brinquedos'             THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriabrinquedos,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'cool_stuff'             THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriacool_stuff,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'ferramentas_jardim'     THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriaferramentas_jardim,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'perfumaria'             THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriaperfumaria,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'bebes'                  THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriabebes,
        CAST(COUNT(DISTINCT CASE WHEN descCategoria = 'eletronicos'            THEN idProduto END) AS FLOAT) / COUNT(DISTINCT idProduto) AS pctCategoriaeletronicos

    FROM tb_join
    GROUP BY idVendedor
)

SELECT
    '2018-01-01' as dtReference,
    *

FROM tb_summary;

-- Uma query auxiliar para obter o top 15 de categorias de produtos mais vendidos
SELECT
    descCategoria

FROM item_pedido AS t2

LEFT JOIN produto AS t3
ON t2.idProduto = t3.idProduto

WHERE t2.idVendedor IS NOT NULL

GROUP BY 1
ORDER BY COUNT(DISTINCT idPedido) DESC

LIMIT 15;
