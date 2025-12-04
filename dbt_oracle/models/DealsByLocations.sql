{{ config(materialized='table') }}


/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

SELECT DISTINCT
        d.deal_id,
        d.organization_id,
        d.description,
        d.effective_date,
        d.expiration_date,
        d.primary_deal,
        d.stackable,
        d.promotion_type,
        d.auto_fire_ind,
        d.serialized_ind,
        d.serialized_prefix,
        d.markdown_ind,
        d.buy_all_ind,
        dbms_lob.substr(d.long_text)    long_text,
        d.employee_ceiling_ind,
        d.validity_days,
        d.coupon_count,
        d.calculation_method,
        d.calculation_amount,
        locations.store_id,
        locations.pricing_group,
        d.overwrite_ind,
        nvl(da.relational_ind, 0)       relational_ind,
        nvl(da.relational_child_ind, 0) relational_child_ind        ,
                d.vat_ind,
                d.multi_order_ind
    FROM
        deals_own.deals d,
        (
            SELECT
                dl.deal_id,
                dl.organization_id,
                sh.store_id,
                sh.pricing_group
            FROM
                deals_own.store_hierarchy sh,
                deals_own.deals_location  dl
            WHERE
                    dl.org_code = 'PRICING_GROUP'
                AND sh.pricing_group = dl.org_value
            UNION ALL
            SELECT
                dl.deal_id,
                dl.organization_id,
                sh.store_id,
                sh.pricing_group
            FROM
                deals_own.store_hierarchy sh,
                deals_own.deals_location  dl
            WHERE
                    dl.org_code = 'STORE'
                AND sh.store_id = dl.org_value
        )     locations, (
            SELECT DISTINCT
                d.deal_id,
                d.organization_id,
                CASE
                    WHEN da.child_deal_id IS NOT NULL THEN
                        1
                    ELSE
                        0
                END relational_ind,
                0   relational_child_ind
            FROM
                     deals_own.deals d
                JOIN deals_own.deal_application da ON d.deal_id = da.deal_id
                                            AND da.type in  ('OPTION')
            UNION ALL
            SELECT DISTINCT
                d.deal_id,
                d.organization_id,
                0   relational_ind,
                CASE
                    WHEN d.deal_id = da.child_deal_id THEN
                        1
                    ELSE
                        0
                END relational_child_ind
            FROM
                     deals_own.deals d
                JOIN deals_own.deal_application da ON d.deal_id = da.child_deal_id
                                            AND da.type in  ('OPTION')
        )  da
    WHERE
            locations.deal_id = d.deal_id
        AND locations.organization_id = d.organization_id
        AND locations.deal_id = da.deal_id (+)