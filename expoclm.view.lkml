view: expoclm {
  derived_table: {
    sql: SELECT
           e.polnum,
           e.scheme_number,
           e.evy,
           e.exposure_asat,
           e.exposure_start,
           e.exposure_end,
           e.net_premium,
           e.eprem,
           e.inception_strategy,
           e.origin,
           e.policy_type,
           to_timestamp(e.inception) as inception,
           e.aauicl_tenure,
           e.tp_count,
           e.ad_count,
           e.pi_count,
           e.ot_count,
           e.ws_count,
           e.total_incurred,
           e.total_incurred_cap_50k,
           e.total_incurred_cap_25k,
           e.total_count_exc_ws,
           e.reported_count_exc_ws,
           e.rco1_coverstartdate1,
           e.consumer_name,
           e.value,
           e.mileage,
           e.rveti1_yearofregistration1,
           e.purchase_dttm_,
           e.ad_rated_area,
           e.tp_rated_area,
           e.pi_rated_area,
           e.postal_region,
           e.policy_convictions_5yrs,
           e.f_claims_1yr,
           e.nf_claims_1yr,
           e.f_claims_5yrs,
           e.nf_claims_5yrs,
           e.dob_d1,
           e.rpr1_mld1_licencequalifyingdate1,
           e.ncd_years,
           e.financial_year,
           g.postcode_area
         FROM expoclm e
         LEFT JOIN postcode_geography g
          ON replace(e.postcode,' ','') = g.postcode
     ;;
  }

  dimension_group: inception {
    type: time
    timeframes: [
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inception ;;
  }

  dimension: scheme_number {
    type: string
    sql: ${TABLE}.scheme_number ;;
  }

  dimension: policy_origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: policy_type {
    type: string
    sql: ${TABLE}.policy_type ;;
  }

  dimension: aauicl_tenure {
    label: "AAUICL Tenure"
    type: string
    sql: ${TABLE}.aauicl_tenure ;;
  }

  dimension: financial_year {
    type: string
    sql: ${TABLE}.financial_year ;;
  }

  dimension: inception_strategy {
    type: string
    sql: ${TABLE}.inception_strategy ;;
  }

  dimension: consumer_name {
    label: "Channel"
    type: string
    sql: ${TABLE}.consumer_name ;;
  }

  dimension: vehicle_value {
    type: tier
    tiers: [1000,5000,10000,20000,40000]
    style: integer
    sql: ${TABLE}.value ;;
    value_format_name: gbp_0
  }

  dimension: vehicle_age {
    type: tier
    tiers: [1,2,5,10]
    style: integer
    sql: year(rco1_coverstartdate1)-${TABLE}.rveti1_yearofregistration1 ;;
  }

  dimension: mileage {
    type: tier
    tiers: [2000,5000,10000]
    style: integer
    sql: ${TABLE}.mileage ;;
  }

  dimension: ownership_years {
    type: tier
    tiers: [1,2,5,10]
    style: integer
    sql: floor(months_between(${TABLE}.rco1_coverstartdate1, ${TABLE}.purchase_dttm_)/12) ;;
  }

  dimension: ad_rated_area {
    label: "AD Rated Area"
    type: tier
    tiers: [20,30,40,50]
    style: integer
    sql: ${TABLE}.ad_rated_area ;;
  }

  dimension: pi_rated_area {
    label: "PI Rated Area"
    type: tier
    tiers: [20,30,40,50]
    style: integer
    sql: ${TABLE}.pi_rated_area ;;
  }

  dimension: tp_rated_area {
    label: "TP Rated Area"
    type: tier
    tiers: [20,30,40,50]
    style: integer
    sql: ${TABLE}.tp_rated_area ;;
  }

  dimension: postal_region {
    type: string
    sql: ${TABLE}.postal_region ;;
  }

  dimension: postcode_area {
    type: string
    map_layer_name: uk_postcode_areas
    sql: ${TABLE}.postcode_area ;;
  }

  dimension: policy_convictions {
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: ${TABLE}.policy_convictions_5yrs ;;
    description: "Number of convictions on policy that have happened in the last 5 years"
  }

  dimension: policy_fault_claims {
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: ${TABLE}.f_claims_5yrs ;;
    description: "Number of fault claims on policy that have happened in the last 5 years"
  }

  dimension: policy_nonfault_claims {
    label: "Policy Non-Fault Claims"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: ${TABLE}.nf_claims_5yrs ;;
    description: "Number of non-fault claims on policy that have happened in the last 5 years"
  }

  dimension: policy_fault_claims_1yr {
    label: "Policy Fault Claims (in Last Year)"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: ${TABLE}.f_claims_1yr ;;
    description: "Number of fault claims on policy that have happened in the last year"
  }

  dimension: policy_nonfault_claims_1yr {
    label: "Policy Non-Fault Claims (in Last Year)"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: ${TABLE}.nf_claims_1yr ;;
    description: "Number of non-fault claims on policy that have happened in the last year"
  }

  dimension: policyholder_age {
    type: tier
    tiers: [30,40,50,60,70,80]
    style: integer
    sql: floor(months_between(${TABLE}.rco1_coverstartdate1, ${TABLE}.dob_d1)/12) ;;
  }

  dimension: policyholder_licence_years {
    type: tier
    tiers: [2,5,10]
    style: integer
    sql: floor(months_between(${TABLE}.rco1_coverstartdate1, ${TABLE}.rpr1_mld1_licencequalifyingdate1)/12) ;;
  }

  dimension: ncd_years {
    label: "NCD Years"
    type: tier
    tiers: [2,5,9]
    style: integer
    sql: ${TABLE}.ncd_years ;;
  }


# Measures

  measure: exposure {
    type: sum
    sql: ${TABLE}.evy ;;
    value_format_name: decimal_0
  }

  measure: earned_premium {
    type: sum
    sql: ${TABLE}.eprem ;;
    value_format_name: gbp_0
  }

  measure: average_earned_premium {
    type: number
    sql: ${earned_premium}/nullif(${exposure},0) ;;
    value_format_name: gbp_0
  }

  measure: total_incurred {
    type: sum
    sql: ${TABLE}.total_incurred ;;
    hidden: yes
  }

  measure: total_incurred_cap_50k {
    label: "Total Incurred (Cap 50K)"
    type: sum
    sql: ${TABLE}.total_incurred_cap_50k ;;
    hidden: yes
  }

  measure: total_incurred_cap_25k {
    label: "Total Incurred (Cap 25K)"
    type: sum
    sql: ${TABLE}.total_incurred_cap_25k ;;
    hidden: yes
  }

  measure: total_count_exc_ws {
    label: "Total Count (Exc WS)"
    type: sum
    sql: ${TABLE}.total_count_exc_ws ;;
    hidden: yes
  }

  measure: reported_count_exc_ws {
    label: "Reported Count (Exc WS)"
    type: sum
    sql: ${TABLE}.reported_count_exc_ws ;;
    hidden: yes
  }

  measure: ad_count {
    label: "AD Count"
    type: sum
    sql: ${TABLE}.ad_count ;;
    hidden: yes
  }

  measure: pi_count {
    label: "PI Count"
    type: sum
    sql: ${TABLE}.pi_count ;;
    hidden: yes
  }

  measure: tp_count {
    label: "TP Count"
    type: sum
    sql: ${TABLE}.tp_count ;;
    hidden: yes
  }

  measure: ot_count {
    label: "OT Count"
    type: sum
    sql: ${TABLE}.ot_count ;;
    hidden: yes
  }

  measure: ws_count {
    label: "WS Count"
    type: sum
    sql: ${TABLE}.ws_count ;;
    hidden: yes
  }

  measure: fault_frequency {
    type: number
    sql: ${total_count_exc_ws}/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: nonfault_frequency {
    label: "Non-Fault Frequency"
    type: number
    sql: (${reported_count_exc_ws}-${total_count_exc_ws})/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: ad_frequency {
    label: "AD Frequency"
    type: number
    sql: ${ad_count}/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: pi_frequency {
    label: "PI Frequency"
    type: number
    sql: ${pi_count}/nullif(${exposure},0) ;;
    value_format_name: percent_2
  }

  measure: tp_frequency {
    label: "TP Frequency"
    type: number
    sql: ${tp_count}/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: ot_frequency {
    label: "OT Frequency"
    type: number
    sql: ${ot_count}/nullif(${exposure},0) ;;
    value_format_name: percent_2
  }

  measure: ws_frequency {
    label: "WS Frequency"
    type: number
    sql: ${ws_count}/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: loss_ratio {
    label: "Loss Ratio (Uncapped)"
    type: number
    sql: ${total_incurred}/nullif(${earned_premium},0) ;;
    value_format_name: percent_1
  }

  measure: loss_ratio_cap_50k {
    label: "Loss Ratio (Cap 50K)"
    type: number
    sql: ${total_incurred_cap_50k}/nullif(${earned_premium},0) ;;
    value_format_name: percent_1
  }

  measure: loss_ratio_cap_25k {
    label: "Loss Ratio (Cap 25K)"
    type: number
    sql: ${total_incurred_cap_25k}/nullif(${earned_premium},0) ;;
    value_format_name: percent_1
  }

}
