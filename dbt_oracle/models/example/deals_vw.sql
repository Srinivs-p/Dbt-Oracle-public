{{ config(materialized='table') }}

SELECT
            deal_id,
            organization_id,
            description,
            MAX(created) created
        FROM
            deals_stg.deals
        WHERE
            processed IS NULL
        GROUP BY
            deal_id,
            organization_id,
            description