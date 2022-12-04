---------- Query query which derives the total transactions per date and country based on the channel grouping! -----------------------------------------------------------

WITH transactiom_ecommerce AS (
  SELECT
    channelGrouping channel,
    ARRAY_AGG(
      STRUCT(trans_ec.date, geoNetwork_country AS country)
      ORDER BY trans_ec.date ASC, geoNetwork_country ASC
    ) level, 

    SUM(totals_transactions) transact_per_level_channel, 
  FROM `data-to-insights.ecommerce.rev_transactions` trans_ec
  WHERE NOT geoNetwork_country = "(not set)" AND NOT channelGrouping = "(Other)" 
  GROUP BY channelGrouping, trans_ec.date, geoNetwork_country
),



 full_total_transaction_per_channel  AS(
  SELECT
    channelGrouping channel, 
    SUM(totals_transactions) total_transact_per_channel
  FROM `data-to-insights.ecommerce.rev_transactions` 
  GROUP BY channelGrouping
)



SELECT 
  total_transact_per_channel,
  te.channel,
  level,
  transact_per_level_channel
FROM transactiom_ecommerce te
INNER JOIN full_total_transaction_per_channel ftc
ON te.channel = ftc.channel
ORDER BY
  total_transact_per_channel DESC,
  transact_per_level_channel DESC

----------------------------------------------------------- END ----------------------------------------------------------------------------------------------------------------
