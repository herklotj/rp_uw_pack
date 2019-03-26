view: expoclm {
  sql_table_name: aapricing.expoclm ;;

  dimension: scheme_number {
    type: string
    sql: ${TABLE}.scheme_number ;;
  }

  dimension: financial_year {
    type: string
    sql: ${TABLE}.financial_year ;;
  }

  dimension: inception_strategy {
    type: string
    sql: ${TABLE}.inception_strategy ;;
  }

  dimension: vehicle_value {
    type: tier
    tiers: [10000,20000,30000]
    style: integer
    sql: ${TABLE}.value ;;
    value_format_name: gbp_0
  }

  dimension: vehicle_age {
    type: tier
    tiers: [1,3,5,10,15]
    style: integer
    sql: year(rco1_coverstartdate1)-${TABLE}.rveti1_yearofregistration1 ;;
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
  }

  measure: total_incurred {
    type: sum
    sql: ${TABLE}.total_incurred ;;
  }

  measure: total_incurred_cap_50k {
    label: "Total Incurred (Cap 50K)"
    type: sum
    sql: ${TABLE}.total_incurred_cap_50k ;;
  }

  measure: total_count_exc_ws {
    label: "Total Count (Exc WS)"
    type: sum
    sql: ${TABLE}.total_count_exc_ws ;;
  }

  measure: reported_count_exc_ws {
    label: "Reported Count (Exc WS)"
    type: sum
    sql: ${TABLE}.reported_count_exc_ws ;;
  }

  measure: ad_count {
    label: "AD Count"
    type: sum
    sql: ${TABLE}.ad_count ;;
  }

  measure: pi_count {
    label: "PI Count"
    type: sum
    sql: ${TABLE}.pi_count ;;
  }

  measure: tp_count {
    label: "TP Count"
    type: sum
    sql: ${TABLE}.tp_count ;;
  }

  measure: ot_count {
    label: "OT Count"
    type: sum
    sql: ${TABLE}.ot_count ;;
  }

  measure: ws_count {
    label: "WS Count"
    type: sum
    sql: ${TABLE}.ws_count ;;
  }

  measure: fault_frequency {
    type: number
    sql: ${total_count_exc_ws}/${exposure} ;;
  }

  measure: nonfault_frequency {
    label: "Non-Fault Frequency"
    type: number
    sql: (${reported_count_exc_ws}-${total_count_exc_ws})/${exposure} ;;
  }

  measure: ad_frequency {
    label: "AD Frequency"
    type: number
    sql: ${ad_count}/${exposure} ;;
  }

  measure: pi_frequency {
    label: "PI Frequency"
    type: number
    sql: ${pi_count}/${exposure} ;;
  }

  measure: tp_frequency {
    label: "TP Frequency"
    type: number
    sql: ${tp_count}/${exposure} ;;
  }

  measure: ot_frequency {
    label: "OT Frequency"
    type: number
    sql: ${ot_count}/${exposure} ;;
  }

  measure: ws_frequency {
    label: "WS Frequency"
    type: number
    sql: ${ws_count}/${exposure} ;;
  }

  measure: loss_ratio {
    label: "Loss Ratio (Uncapped)"
    type: number
    sql: ${total_incurred}/${earned_premium} ;;
    value_format_name: percent_1
  }

  measure: loss_ratio_cap_50k {
    label: "Loss Ratio (Cap 50K)"
    type: number
    sql: ${total_incurred_cap_50k}/${earned_premium} ;;
    value_format_name: percent_1
  }

}
