view: expoclm {
  derived_table: {
    sql:
    SELECT
        *,
        (case when transaction_type in ('CrossQuote', 'Renewal')
                then
                  predicted_ad_freq*predicted_ad_sev+ predicted_pi_freq*predicted_pi_sev+ predicted_tp_freq*predicted_tp_sev+ predicted_ot_freq*predicted_ot_sev+ predicted_ws_freq*predicted_ws_sev
              else
                  predicted_ad_freq*predicted_ad_sev+ predicted_pi_freq*predicted_pi_sev+ predicted_tp_freq*predicted_tp_sev+ predicted_ot_freq*predicted_ot_sev+ predicted_ws_freq*predicted_ws_sev
                         end)*evy
          as predicted_incurred_resv3,
        (case when transaction_type in ('CrossQuote', 'Renewal')
                then
                  predicted_ad_freq_aug18*predicted_ad_sev_aug18+ predicted_pi_freq_aug18*predicted_pi_sev_aug18+ predicted_tp_freq_aug18*predicted_tp_sev_aug18+ predicted_ot_freq_aug18*predicted_ot_sev_aug18+ predicted_ws_freq_aug18*predicted_ws_sev_aug18
              else
                  predicted_ad_freq_aug18*predicted_ad_sev_aug18+ predicted_pi_freq_aug18*predicted_pi_sev_aug18+ predicted_tp_freq_aug18*predicted_tp_sev_aug18+ predicted_ot_freq_aug18*predicted_ot_sev_aug18+ predicted_ws_freq_aug18*predicted_ws_sev_aug18
              end)*evy
          as predicted_incurred_aug18,
          (case when transaction_type in ('CrossQuote', 'Renewal')
                then
                  predicted_ad_freq_jul19cred*predicted_ad_sev_jul19cred+ predicted_pi_freq_jul19cred*predicted_pi_sev_jul19cred+ predicted_tp_freq_jul19cred*predicted_tp_sev_jul19cred+ predicted_ot_freq_jul19cred*predicted_ot_sev_jul19cred+ predicted_ws_freq_jul19cred*predicted_ws_sev_jul19cred
              else
                  predicted_ad_freq_jul19cred*predicted_ad_sev_jul19cred+ predicted_pi_freq_jul19cred*predicted_pi_sev_jul19cred+ predicted_tp_freq_jul19cred*predicted_tp_sev_jul19cred+ predicted_ot_freq_jul19cred*predicted_ot_sev_jul19cred+ predicted_ws_freq_jul19cred*predicted_ws_sev_jul19cred
              end)*evy
          as predicted_incurred_jul19cred,
        case when predicted_ad_freq_aug18 > 0 and predicted_ad_freq > 0 then 'Y' else 'N' end as risk_scores,
        case when termincep >'2018-08-01' then 'Post Aug18' else 'Pre Aug18' end as holdout_aug18,
        case when termincep >'2019-01-01' then 'Post Jul19' else 'Pre Jul19' end as holdout_jul19,

        case
        when transaction_type in ('CrossQuote', 'Renewal') then
          predicted_ad_freq*1.08*predicted_ad_sev*1.24+
          predicted_pi_freq*1.19*predicted_pi_sev*0.86+
          predicted_tp_freq*0.97*predicted_tp_sev*1.30+
          predicted_ot_freq*0.73*predicted_ot_sev*2.02+
          predicted_ws_freq*0.82*predicted_ws_sev*1.28+
          18
        else
          predicted_ad_freq*1.07*predicted_ad_sev*1.21+
          predicted_pi_freq*0.95*predicted_pi_sev*0.85+
          predicted_tp_freq*0.84*predicted_tp_sev*1.34+
          predicted_ot_freq*0.57*predicted_ot_sev*2.70+
          predicted_ws_freq*0.83*predicted_ws_sev*1.24+
          18
      end as predicted_bc

    FROM
      (
      SELECT
            e.polnum,
            e.add_match,
            e.delphi_score,
            e.scheme_number,
            e.scheme,
            e.evy,
            e.exposure_asat,
            e.exposure_start,
            e.exposure_end,
            date_trunc('quarter',e.exposure_start) as acc_quarter,
            e.net_premium,
            e.eprem,
            e.transaction_type,
            e.inception_strategy,
            e.origin,
            e.policy_type,
            e.transaction_type,
            to_timestamp(e.inception) as inception,
            to_timestamp(e.termincep) as termincep,
            e.aauicl_tenure,
            e.tp_count,
            e.ad_count,
            e.pi_count,
            e.ot_count,
            e.ws_count,
            e.ad_incurred,
            e.tp_incurred,
            e.pi_incurred_cap_50k,
            e.pi_incurred_cap_25k,
            e.pi_incurred,
            e.ws_incurred,
            e.ot_incurred,
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
            e.postal_area,
            e.policy_convictions_5yrs,
            e.f_claims_1yr,
            e.nf_claims_1yr,
            e.f_claims_5yrs,
            e.nf_claims_5yrs,
            e.dob_d1,
            LEAST(dob_d1,dob_d2,dob_d3,dob_d4,dob_d5) as min_dob,
            e.rpr1_mld1_licencequalifyingdate1,
            e.ncd_years,
            e.financial_year,
            e.manufacturer,
            e.fuel_type,
            e.protected_ncd,
            e.owner_type,
            e.rveti1_registeredkeeper1,
            e.body_style,
            e.transmission,
            e.power_bhp,
            e.engine_size,
            e.e0ved1_kcd1_numberpreviouskeepers1,
            e.vol_xs,
            e.age_mem_yrs,
            e.member_score_unbanded,
            e.parking_type,
            e.ppopulationdensity,
            e.rpr1_maindriver1,
            e.rpr1_ownsothervehicles1,
            e.rpr1_noofothervehiclesdriven1,
            e.min_age,
            e.leadtime,
            ra.ad_ra_update,
            ra.tp_ra_update,
            ra.pi_ra_update,
            cov.quote_dttm,
            rreh1_requestdatetime1,
            occupation_type_d1,
            occupation_type_d2,
            occupation_type_d3,
            occupation_type_d4,
            case when ncdp = 'N' then res.predicted_ad_freq_an*1.11 else res.predicted_ad_freq_ap*1.11 end as predicted_ad_freq,
            case when ncdp = 'N' then res.predicted_ad_sev_an*1.25 else res.predicted_ad_sev_ap*1.25 end as predicted_ad_sev,
            case when ncdp = 'N' then res.predicted_pi_freq_an*1.06 else res.predicted_pi_freq_ap*1.06 end as predicted_pi_freq,
            case when ncdp = 'N' then res.predicted_pi_sev_an*0.85 else res.predicted_pi_sev_ap*0.85 end as predicted_pi_sev,
            case when ncdp = 'N' then res.predicted_tpd_freq_an*0.9 else res.predicted_tpd_freq_ap*0.9 end as predicted_tp_freq,
            case when ncdp = 'N' then res.predicted_tpd_sev_an*1.5 else res.predicted_tpd_sev_ap*1.5 end as predicted_tp_sev,
            case when ncdp = 'N' then res.predicted_ot_freq_an*0.78 else res.predicted_ot_freq_ap*0.78 end as predicted_ot_freq,
            case when ncdp = 'N' then res.predicted_ot_sev_an*2.7 else res.predicted_ot_sev_ap*2.7 end as predicted_ot_sev,
            case when ncdp = 'N' then res.predicted_ws_freq_an*0.83 else res.predicted_ws_freq_ap*0.83 end as predicted_ws_freq,
            case when ncdp = 'N' then res.predicted_ws_sev_an*1.42 else res.predicted_ws_sev_ap*1.42 end as predicted_ws_sev,
            case when ncdp = 'N' then aug.predicted_ad_freq_an*aug18sc.AD_F else aug.predicted_ad_freq_ap*aug18sc.AD_F end as predicted_ad_freq_aug18,
            case when ncdp = 'N' then aug.predicted_ad_sev_an*aug18sc.AD_S else aug.predicted_ad_sev_ap*aug18sc.AD_S end as predicted_ad_sev_aug18,
            case when ncdp = 'N' then aug.predicted_pi_freq_an*aug18sc.PI_F else aug.predicted_pi_freq_ap*aug18sc.PI_F end as predicted_pi_freq_aug18,
            case when ncdp = 'N' then aug.predicted_pi_sev_an*aug18sc.PI_S else aug.predicted_pi_sev_ap*aug18sc.PI_S end as predicted_pi_sev_aug18,
            case when ncdp = 'N' then aug.predicted_tpd_freq_an*aug18sc.TP_F else aug.predicted_tpd_freq_ap*aug18sc.TP_F end as predicted_tp_freq_aug18,
            case when ncdp = 'N' then aug.predicted_tpd_sev_an*aug18sc.TP_S else aug.predicted_tpd_sev_ap*aug18sc.TP_S end as predicted_tp_sev_aug18,
            case when ncdp = 'N' then aug.predicted_ot_freq_an*aug18sc.OT_F else aug.predicted_ot_freq_ap*aug18sc.OT_F end as predicted_ot_freq_aug18,
            case when ncdp = 'N' then aug.predicted_ot_sev_an*aug18sc.OT_S else aug.predicted_ot_sev_ap*aug18sc.OT_S end as predicted_ot_sev_aug18,
            case when ncdp = 'N' then aug.predicted_ws_freq_an*aug18sc.WS_F else aug.predicted_ws_freq_ap*aug18sc.WS_F end as predicted_ws_freq_aug18,
            case when ncdp = 'N' then aug.predicted_ws_sev_an*aug18sc.WS_S else aug.predicted_ws_sev_ap*aug18sc.WS_S end as predicted_ws_sev_aug18,

            case when ncdp = 'N' then jcred.predicted_ad_freq_an*jcredsc.AD_F else jcred.predicted_ad_freq_ap*jcredsc.AD_F end * 1.05 as predicted_ad_freq_jul19cred,
            case when ncdp = 'N' then jcred.predicted_ad_sev_an*jcredsc.AD_S else jcred.predicted_ad_sev_ap*jcredsc.AD_S end * 1.16  as predicted_ad_sev_jul19cred,
            case when ncdp = 'N' then jcred.predicted_pi_freq_an*jcredsc.PI_F else jcred.predicted_pi_freq_ap*jcredsc.PI_F end * 0.99 as predicted_pi_freq_jul19cred,
            case when ncdp = 'N' then jcred.predicted_pi_sev_an*jcredsc.PI_S else jcred.predicted_pi_sev_ap*jcredsc.PI_S end * 0.92 as predicted_pi_sev_jul19cred,
            case when ncdp = 'N' then jcred.predicted_tpd_freq_an*jcredsc.TP_F else jcred.predicted_tpd_freq_ap*jcredsc.TP_F end *0.92 as predicted_tp_freq_jul19cred,
            case when ncdp = 'N' then jcred.predicted_tpd_sev_an*jcredsc.TP_S else jcred.predicted_tpd_sev_ap*jcredsc.TP_S end  * 1.23 as predicted_tp_sev_jul19cred,
            case when ncdp = 'N' then jcred.predicted_ot_freq_an*jcredsc.OT_F else jcred.predicted_ot_freq_ap*jcredsc.OT_F end * 0.90 as predicted_ot_freq_jul19cred,
            case when ncdp = 'N' then jcred.predicted_ot_sev_an*jcredsc.OT_S else jcred.predicted_ot_sev_ap*jcredsc.OT_S end * 2.02 as predicted_ot_sev_jul19cred,
            case when ncdp = 'N' then jcred.predicted_ws_freq_an*jcredsc.WS_F else jcred.predicted_ws_freq_ap*jcredsc.WS_F end * 0.895 as predicted_ws_freq_jul19cred,
            case when ncdp = 'N' then jcred.predicted_ws_sev_an*jcredsc.WS_S else jcred.predicted_ws_sev_ap*jcredsc.WS_S end * 1.22 as predicted_ws_sev_jul19cred,
            e.originator_name,
            e.uwyr,
            case when timestampdiff (YEAR,dob_d1,sysdate) > 70  OR timestampdiff (YEAR,dob_d2,sysdate) > 70 OR timestampdiff (YEAR,dob_d3,sysdate) > 70 OR timestampdiff (YEAR,dob_d4,sysdate) > 70 then 1 else 0 end as age_70_flag,
            case when (f_claims_5yrs + policy_convictions_5yrs = 1) then 1 else 0 end as claim_conv_1,
            case when timestampdiff (YEAR,dob_d1,sysdate) > 70 AND (d1_claims >= 1 OR timestampdiff (YEAR,conviction_date_d1_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d2,sysdate) > 70 AND (d2_claims >= 1 OR timestampdiff (YEAR,conviction_date_d2_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d3,sysdate) > 70 AND (d3_claims >= 1 OR timestampdiff (YEAR,conviction_date_d3_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d4,sysdate) > 70 AND (d4_claims >= 1 OR timestampdiff (YEAR,conviction_date_d4_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn5,sysdate) < 5) then 1 else 0 end as d70_fail,
            case when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d2 IN ('S', 'W') AND occupation_type_d2 = 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d3 IN ('S', 'W') AND occupation_type_d3 = 'U03')
            AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d4 IN ('S', 'W') AND occupation_type_d4 = 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) then 1      else 0 end as business_rule_2,
            case when occupation_type_d1 = 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d2 IN ('S', 'W') AND occupation_type_d2 != 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 = 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d3 IN ('S', 'W') AND occupation_type_d3 != 'U03')
            AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 = 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d4 IN ('S', 'W') AND occupation_type_d4 != 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) then 1     else 0 end as business_rule_3,
            case when f_claims_5yrs = 1 AND policy_convictions_5yrs = 1 then 1 else 0 end as claim_conv_2,
            case when d1_claims = 1 AND (timestampdiff (YEAR,conviction_date_d1_cn1,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d1_cn2,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d1_cn3,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d1_cn4,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d1_cn5,sysdate) < 5 ) then 1
            when d2_claims = 1 AND (timestampdiff (YEAR,conviction_date_d2_cn1,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d2_cn2,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d2_cn3,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d2_cn4,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d2_cn5,sysdate) < 5 ) then 1
            when d3_claims = 1 AND (timestampdiff (YEAR,conviction_date_d3_cn1,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d3_cn2,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d3_cn3,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d3_cn4,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d3_cn5,sysdate) < 5 ) then 1
            when d4_claims = 1 AND (timestampdiff (YEAR,conviction_date_d4_cn1,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d4_cn2,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d4_cn3,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d4_cn4,sysdate) < 5  OR timestampdiff (YEAR,conviction_date_d4_cn5,sysdate) < 5 ) then 1
            else 0 end as d_fail,
            case when timestampdiff (YEAR,dob_d1,sysdate) BETWEEN 76 AND 79  OR timestampdiff (YEAR,dob_d2,sysdate) BETWEEN 76 AND 79 OR timestampdiff (YEAR,dob_d3,sysdate) BETWEEN 76 AND 79 OR timestampdiff (YEAR,dob_d4,sysdate) BETWEEN 76 AND 79 then 1 else 0 end as age_79_flag,
            case when timestampdiff (YEAR,dob_d1,sysdate) BETWEEN 76 AND 79 AND (d1_claims >= 1 OR timestampdiff (YEAR,conviction_date_d1_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d1_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d2,sysdate) BETWEEN 76 AND 79 AND (d2_claims >= 1 OR timestampdiff (YEAR,conviction_date_d2_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d2_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d3,sysdate) BETWEEN 76 AND 79 AND (d3_claims >= 1 OR timestampdiff (YEAR,conviction_date_d3_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d3_cn5,sysdate) < 5) then 1
            when timestampdiff (YEAR,dob_d4,sysdate) BETWEEN 76 AND 79 AND (d4_claims >= 1 OR timestampdiff (YEAR,conviction_date_d4_cn1,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn2,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn3,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn4,sysdate) < 5 OR timestampdiff (YEAR,conviction_date_d4_cn5,sysdate) < 5) then 1 else 0 end as d79_fail


         FROM
            expoclm_quarters e
         left join
              aapricing.uncalibrated_scores_aug18 aug
              on left(e.quote_id, 36) = left(aug.quote_id, 36)
         left join
              aapricing.uncalibrated_scores_jul19_cred jcred
              on left(e.quote_id, 36) = left(jcred.quote_id, 36)
         left join
              aapricing.uncalibrated_scores res
              on left(e.quote_id, 36) = left(res.quote_id, 36)
         left join
              motor_model_calibrations aug18sc
              on aug18sc.policy_start_month = date_trunc('month',e.termincep) and aug18sc.model='August_18_pricing' and aug18sc.end = '9999-01-01'
         left join
              motor_model_calibrations jcredsc
              on jcredsc.policy_start_month = date_trunc('month',e.termincep) and jcredsc.model='July_19_Cred_Pric' and jcredsc.end = '9999-01-01'
         left join
              ra_update ra
              on ra.postcode_sector = left(replace(e.postcode,' ',''),length(replace(e.postcode,' ',''))-2)
         left join
              qs_cover cov
              on e.quote_id = cov.quote_id AND e.quote_id != ' ' AND to_date(cov.quote_dttm) != '2999-12-31' AND e.quote_id IS NOT NULL
      )f
     ;;
  }

  dimension: polnum {
    type:  string
    sql:  ${TABLE}.polnum ;;
  }
  dimension: exposure_start {
    type:  date_time
    sql:  ${TABLE}.exposure_start ;;
  }
  dimension: exposure_end {
    type:  date_time
    sql:  ${TABLE}.exposure_end ;;
  }

  dimension_group: inception {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inception ;;
  }

  dimension_group: request_date {
    type: time
    timeframes: [
      month,
      quarter,
      year,
      week
    ]
    sql: ${TABLE}.rreh1_requestdatetime1 ;;
  }

  dimension_group: term_inception {
    type: time
    timeframes: [
      month,
      quarter,
      year,
      week
    ]
    sql: ${TABLE}.termincep ;;
    }

  dimension_group: quote_date {
    type: time
    timeframes: [
      month,
      quarter,
      year,
      week
    ]
    sql: ${TABLE}.quote_dttm ;;
  }

  dimension: Accident_Quarter {
    type: date_quarter
    sql: ${TABLE}.acc_quarter ;;

  }

  dimension: age_mem_years {
    type: string
    sql: ${TABLE}.age_mem_yrs ;;

  }

  dimension: scheme {
    type: string
    sql: ${TABLE}.scheme ;;

    }


  dimension: address_match {
    type: string
    sql: ${TABLE}.add_match ;;


  }

  dimension: delphi_score {
    type: tier
    tiers: [700, 800, 875]
    style: relational
    sql: ${TABLE}.delphi_score ;;

  }


  dimension: member_score {
    type: tier
    tiers:[0, 0.8, 0.9, 1, 1.1]
    style: relational
    sql: ${TABLE}.member_score_unbanded ;;

  }

  dimension: Underwriting_Year {
    type: string
    sql: ${TABLE}.uwyr ;;
  }

  dimension: scheme_number {
    type: string
    sql: ${TABLE}.scheme_number ;;
  }

  dimension: policy_origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: NCDP {
    type: string
    sql: ${TABLE}.protected_ncd ;;
  }

  dimension: policy_type {
    type: string
    sql: ${TABLE}.policy_type ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
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
    tiers: [500, 1500, 5000, 10000,20000,40000]
    style: integer
    sql: ${TABLE}.value ;;
    value_format_name: gbp_0
  }

  dimension: vehicle_age {
    type: tier
    tiers: [0, 4, 8, 12]
    style: integer
    sql: year(termincep)-${TABLE}.rveti1_yearofregistration1 ;;
  }

  dimension: manufacturer {
    label: "Vehicle Make"
    type: string
    sql: ${TABLE}.manufacturer ;;
  }


  dimension: mileage {
    type: tier
    tiers: [2000,5000,10000]
    style: integer
    sql: ${TABLE}.mileage ;;
  }

  dimension: ownership_years {
    type: tier
    tiers: [0, 1, 4, 8]
    style: integer
    sql: floor(months_between(termincep, ${TABLE}.purchase_dttm_)/12) ;;
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
    tiers: [0, 20, 30, 40]
    style: integer
    sql: ${TABLE}.pi_rated_area ;;
  }

  dimension: tp_rated_area {
    label: "TP Rated Area"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50]
    style: integer
    sql: ${TABLE}.tp_rated_area ;;
  }

  dimension: ad_ra_update {
    label: "New AD Rated Area"
    type: tier
    tiers: [20,40,60,80]
    style: integer
    sql: ${TABLE}.ad_ra_update ;;
  }

  dimension: tp_ra_update {
    label: "New TP Rated Area"
    type: tier
    tiers: [20,40,60,80]
    style: integer
    sql: ${TABLE}.tp_ra_update ;;
  }

  dimension: pi_ra_update {
    label: "New PI Rated Area"
    type: tier
    tiers: [20,40,60,80]
    style: integer
    sql: ${TABLE}.pi_ra_update ;;
  }

  dimension: postal_region {
    type: string
    sql: ${TABLE}.postal_region ;;
  }

  dimension: postcode_area {
    type: string
    map_layer_name: uk_postcode_areas
    sql: ${TABLE}.postal_area ;;
  }


  dimension: fuel_type {
    label: "Fuel"
    type: string
    sql: case when ${TABLE}.fuel_type = 'P' then 'Petrol'
              when  ${TABLE}.fuel_type = 'D' then 'Diesel'
              when ${TABLE}.fuel_type = 'E' then 'Electric'
              else 'Unknown' end;;
  }

  dimension: policy_convictions {
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: coalesce(${TABLE}.policy_convictions_5yrs,0) ;;
    description: "Number of convictions on policy that have happened in the last 5 years"
  }

  dimension: policy_fault_claims {
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: coalesce(${TABLE}.f_claims_5yrs,0) ;;
    description: "Number of fault claims on policy that have happened in the last 5 years"
  }

  dimension: policy_nonfault_claims {
    label: "Policy Non-Fault Claims"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: coalesce(${TABLE}.nf_claims_5yrs,0) ;;
    description: "Number of non-fault claims on policy that have happened in the last 5 years"
  }

  dimension: policy_fault_claims_1yr {
    label: "Policy Fault Claims (in Last Year)"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: coalesce(${TABLE}.f_claims_1yr,0) ;;
    description: "Number of fault claims on policy that have happened in the last year"
  }

  dimension: policy_nonfault_claims_1yr {
    label: "Policy Non-Fault Claims (in Last Year)"
    type: tier
    tiers: [1,2,3]
    style: integer
    sql: coalesce(${TABLE}.nf_claims_1yr,0) ;;
    description: "Number of non-fault claims on policy that have happened in the last year"
  }

  dimension: policyholder_age {
    type: tier
    tiers: [30,40,50,60,70,75,80]
    style: integer
    sql: floor(months_between(${TABLE}.termincep, ${TABLE}.dob_d1)/12) ;;
  }

  dimension: policyholder_age_2 {
    type: tier
    tiers: [25,26,27,28,29,30,40,50,60,70,80]
    style: integer
    sql: floor(months_between(${TABLE}.termincep, ${TABLE}.dob_d1)/12) ;;
  }

  dimension: max_age {
    type: tier
    tiers: [30,40,50,60,70,75,80]
    style: integer
    sql: floor(months_between(${TABLE}.termincep, ${TABLE}.min_dob)/12) ;;
  }

  dimension: policyholder_licence_years {
    type: tier
    tiers: [2,5,10]
    style: integer
    sql: floor(months_between(${TABLE}.termincep, ${TABLE}.rpr1_mld1_licencequalifyingdate1)/12) ;;
  }

  dimension: ncd_years {
    label: "NCD Years"
    type: tier
    tiers: [0, 1, 4, 9]
    style: integer
    sql: ${TABLE}.ncd_years ;;
  }

  dimension: transmission {
    label: "Transmission"
    type: string
    sql: case when ${TABLE}.transmission = 'M' then 'Manual'
              when  ${TABLE}.transmission = 'A' then 'Automatic'
              else 'Unknown' end;;
  }

  dimension: body_style {
    label: "Body Style"
    type: string
    sql: nullif(${TABLE}.body_style,'');;
  }

  dimension: engine_size {
    label: "Engine Size"
    type: tier
    tiers: [1,1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0,3.5,4.0,4.5,5]
    style: relational
    sql: round(nullif(${TABLE}.engine_size,-99999) /1000.0,1);;
    value_format: "0.0\"L\""
  }

  dimension: power_bhp {
    label: "BHP"
    type: tier
    tiers: [80,100,110,120,130,140,150,160,170,180,200,250,300]
    style: integer
    sql: round(nullif(${TABLE}.power_bhp,-99999),0.1);;
  }

  dimension: owner_type {
    label: "Vehicle Owner"
    type: string
    sql: case when ${TABLE}.owner_type = '1' then 'Policy Holder'
              when ${TABLE}.owner_type = '2' then 'Spouse'
              when ${TABLE}.owner_type = '3' then 'Company'
              when ${TABLE}.owner_type = '4' then 'Leasing Company'
              when ${TABLE}.owner_type = '6' then 'Parent'
              when ${TABLE}.owner_type = '9' then 'Other'
              else 'Unknown' end;;
  }

  dimension: rveti1_registeredkeeper1 {
    label: "Vehicle Keeper"
    type: string
    sql: case when ${TABLE}.rveti1_registeredkeeper1 = '1' then 'Policy Holder'
              when ${TABLE}.rveti1_registeredkeeper1 = '2' then 'Spouse'
              when ${TABLE}.rveti1_registeredkeeper1 = '3' then 'Company'
              when ${TABLE}.rveti1_registeredkeeper1 = '4' then 'Leasing Company'
              when ${TABLE}.rveti1_registeredkeeper1 = '6' then 'Parent'
              when ${TABLE}.rveti1_registeredkeeper1 = '9' then 'Other'
              else 'Unknown' end;;
  }

  dimension: e0ved1_kcd1_numberpreviouskeepers1 {
    label: "Number of Previous Keepers"
    type: tier
    tiers: [1,2,3,4,5]
    style: integer
    sql: ${TABLE}.e0ved1_kcd1_numberpreviouskeepers1;;
  }

  dimension: min_age {
    label: "Minimum Age"
    type: tier
    tiers: [30,40,50,60,70,80]
    style: integer
    sql: ${TABLE}.min_age ;;
  }

  dimension: min_age_2 {
    label: "Minimum Age 2"
    type: tier
    tiers: [25,26,27,28,29,30,40,50,60,70,80]
    style: integer
    sql: ${TABLE}.min_age ;;
  }

  dimension: ppopulationdensity {
    label: "Population Density"
    type: number
    sql: nullif(${TABLE}.ppopulationdensity,'');;
  }

  dimension: vol_xs {
    label: "Voluntary Excess"
    type: tier
    tiers: [50,100,150,200,250,300,350,400,450,500]
    style: integer
    sql: nullif(${TABLE}.vol_xs,'');;
  }

  dimension: leadtime {
    label: "Lead Time"
    type: tier
    tiers: [0, 1, 4, 10, 20]
    style: integer
    sql: ${TABLE}.leadtime;;
  }


 dimension: aug18vresv3_bc {
    type: number
    sql: round(
                case when (predicted_incurred_aug18/ nullif(predicted_incurred_resv3,0)-1) > 1 then 1 else round( (predicted_incurred_aug18/ nullif(predicted_incurred_resv3,0)-1) ,1.0) end
                ,1.0)
                ;;
 }

  dimension: jul19credvaug18_bc {
    type: number
    sql: round(
                case when (predicted_incurred_jul19cred/ nullif(predicted_incurred_aug18,0)-1) > 1 then 1 else round( (predicted_incurred_jul19cred/ nullif(predicted_incurred_aug18,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: jul19credvresv3_bc {
    type: number
    sql: round(
                case when (predicted_incurred_jul19cred/ nullif(predicted_incurred_resv3,0)-1) > 1 then 1 else round( (predicted_incurred_jul19cred/ nullif(predicted_incurred_resv3,0)-1) ,1.0) end
                ,1.0)
                ;;
  }


dimension: aug18vresv3_adf {
    type: number
    sql: round(
                case when (predicted_ad_freq_aug18/ nullif(predicted_ad_freq,0)-1) > 1 then 1 else round( (predicted_ad_freq_aug18/ nullif(predicted_ad_freq,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

dimension: aug18vresv3_ads {
    type: number
    sql: round(
                case when (predicted_ad_sev_aug18/ nullif(predicted_ad_sev,0)-1) > 1 then 1 else round( (predicted_ad_sev_aug18/ nullif(predicted_ad_sev,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_adbc {
    type: number
    sql: round(
                case when (predicted_ad_freq_aug18*predicted_ad_sev_aug18*evy/ nullif(predicted_ad_freq*predicted_ad_sev*evy,0)-1) > 1 then 1 else round( (predicted_ad_freq_aug18*predicted_ad_sev_aug18*evy/ nullif(predicted_ad_freq*predicted_ad_sev*evy,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_tpf {
    type: number
    sql: round(
                case when (predicted_tp_freq_aug18/ nullif(predicted_tp_freq,0)-1) > 1 then 1 else round( (predicted_tp_freq_aug18/ nullif(predicted_tp_freq,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_tps {
    type: number
    sql: round(
                case when (predicted_tp_sev_aug18/ nullif(predicted_tp_sev,0)-1) > 1 then 1 else round( (predicted_tp_sev_aug18/ nullif(predicted_tp_sev,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_tpbc {
    type: number
    sql: round(
                case when (predicted_tp_freq_aug18*predicted_tp_sev_aug18*evy/ nullif(predicted_tp_freq*predicted_tp_sev*evy,0)-1) > 1 then 1 else round( (predicted_tp_freq_aug18*predicted_tp_sev_aug18*evy/ nullif(predicted_tp_freq*predicted_tp_sev*evy,0)-1) ,1.0) end
                ,1.0)
                ;;
  }


  dimension: aug18vresv3_pif {
    type: number
    sql: round(
                case when (predicted_pi_freq_aug18/ nullif(predicted_pi_freq,0)-1) > 1 then 1 else round( (predicted_pi_freq_aug18/ nullif(predicted_pi_freq,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_pis {
    type: number
    sql: round(
                case when (predicted_pi_sev_aug18/ nullif(predicted_pi_sev,0)-1) > 1 then 1 else round( (predicted_pi_sev_aug18/ nullif(predicted_pi_sev,0)-1) ,1.0) end
                ,1.0)
                ;;
  }

  dimension: aug18vresv3_pibc {
    type: number
    sql: round(
                case when (predicted_pi_freq_aug18*predicted_pi_sev_aug18*evy/ nullif(predicted_pi_freq*predicted_pi_sev*evy,0)-1) > 1 then 1 else round( (predicted_pi_freq_aug18*predicted_pi_sev_aug18*evy/ nullif(predicted_pi_freq*predicted_pi_sev*evy,0)-1) ,1.0) end
                ,1.0)
                ;;
  }



  dimension: Footprint_expansion{
    type: number
    sql: case when age_70_flag = 1 AND claim_conv_1 = 1 AND d70_fail = 0 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' then 1 when (business_rule_2 = 1 OR business_rule_3 = 1) AND scheme_number = 102 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' then 2 when to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' AND d_fail = 0 AND claim_conv_2 = 1 AND scheme_number = 103 then 3 when age_79_flag = 1 AND d79_fail = 0 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' AND scheme_number = 103 then 4 else 0 end
      ;;
  }




dimension: scores_attached {
    type: string
    sql: risk_scores ;;
}

dimension: holdout_aug18 {
    type: string
    sql: holdout_aug18 ;;
}

  dimension: holdout_jul19 {
    type: string
    sql: holdout_jul19 ;;
  }

  dimension: originator_name  {
    type: string
    sql: originator_name ;;
  }

# Measures

  measure: exposure {
    type: sum
    value_format: "0"
  }

  measure: exposure_mix {
    type: percent_of_total
    sql: ${exposure} ;;
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

  measure: total_incurred_cap_1m {
    label: "Total Incurred (Cap 1m)"
    type: number
    sql: sum(case when total_incurred > 1000000 then 1000000 else total_incurred end) ;;
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

  measure: ad_incurred {
    type: sum
    sql:ad_incurred  ;;

  }

  measure: tp_incurred {
    type: sum
    sql:tp_incurred  ;;

  }

  measure: pi_incurred {
    type: sum
    sql:pi_incurred_cap_25k  ;;

  }

    measure: conversion {
      type: number
      sql: ${TABLE}.conversion ;;

  }

  measure: ot_incurred {
    type: sum
    sql:ot_incurred  ;;

  }

  measure: ws_incurred {
    type: sum
    sql:ws_incurred  ;;

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

  measure: ad_severity {
    label: "AD Severity"
    type: number
    sql: ${ad_incurred} /nullif(${ad_count},0) ;;
    value_format_name: gbp_0
  }

  measure: ad_bc {
    label: "AD Burning Cost"
    type: number
    sql: ${ad_incurred}/nullif(${exposure},0) ;;
    value_format_name: gbp_0
  }

  measure: pi_frequency {
    label: "PI Frequency"
    type: number
    sql: ${pi_count}/nullif(${exposure},0) ;;
    value_format_name: percent_2
  }

  measure: pi_severity {
    label: "PI Severity"
    type: number
    sql: ${pi_incurred} /nullif(${pi_count},0) ;;
    value_format_name: gbp_0
  }

  measure: pi_bc {
    label: "PI Burning Cost"
    type: number
    sql: ${pi_incurred}/nullif(${exposure},0) ;;
    value_format_name: gbp_0
  }


  measure: tp_frequency {
    label: "TP Frequency"
    type: number
    sql: ${tp_count}/nullif(${exposure},0) ;;
    value_format_name: percent_1
  }

  measure: tp_severity {
    label: "TP Severity"
    type: number
    sql: ${tp_incurred} /nullif(${tp_count},0) ;;
    value_format_name: gbp_0
  }

  measure: tp_bc {
    label: "TP Burning Cost"
    type: number
    sql: ${tp_incurred}/nullif(${exposure},0) ;;
    value_format_name: gbp_0
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

  measure: loss_ratio_cap_1m {
    label: "Loss Ratio (Cap 1m)"
    type: number
    sql: ${total_incurred_cap_1m}/nullif(${earned_premium},0) ;;
    value_format_name: percent_1
  }


  measure: pred_loss_ratio_resv3 {
    type: number
    sql: sum(predicted_incurred_resv3)/nullif(sum(case when predicted_incurred_resv3 > 0 then eprem else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_written_loss_ratio_resv3 {
    type: number
    sql: sum(predicted_incurred_resv3)/nullif(sum(case when predicted_incurred_resv3 > 0 then net_premium else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_loss_ratio_aug18 {
    type: number
    sql: sum(predicted_incurred_aug18)/nullif(sum(case when predicted_incurred_aug18 > 0 then eprem else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_loss_ratio_jul19cred {
    type: number
    sql: sum(predicted_incurred_jul19cred)/nullif(sum(case when predicted_incurred_jul19cred > 0 then eprem else 0 end),0) ;;
    value_format_name: percent_1
  }


  measure: pred_ad_freq_resv3 {
    type: number
    sql: sum(predicted_ad_freq*evy)/nullif(sum(case when predicted_ad_freq > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_ad_freq_aug18 {
    type: number
    sql: sum(predicted_ad_freq_aug18*evy)/nullif(sum(case when predicted_ad_freq_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_ad_freq_jul19cred {
    type: number
    sql: sum(predicted_ad_freq_jul19cred*evy)/nullif(sum(case when predicted_ad_freq_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_ad_sev_resv3 {
    type: number
    sql: sum(predicted_ad_sev*evy)/nullif(sum(case when predicted_ad_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_ad_sev_aug18 {
    type: number
    sql: sum(predicted_ad_sev_aug18*evy)/nullif(sum(case when predicted_ad_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_ad_sev_jul19cred {
    type: number
    sql: sum(predicted_ad_sev_jul19cred*evy)/nullif(sum(case when predicted_ad_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_ad_bc_resv3 {
    type: number
    sql: sum(predicted_ad_freq*predicted_ad_sev*evy)/nullif(sum(case when predicted_ad_freq*predicted_ad_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_ad_bc_aug18 {
    type: number
    sql: sum(predicted_ad_freq_aug18*predicted_ad_sev_aug18*evy)/nullif(sum(case when predicted_ad_freq_aug18*predicted_ad_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_ad_bc_jul19cred {
    type: number
    sql: sum(predicted_ad_freq_jul19cred*predicted_ad_sev_jul19cred*evy)/nullif(sum(case when predicted_ad_freq_jul19cred*predicted_ad_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_freq_resv3 {
    type: number
    sql: sum(predicted_tp_freq*evy)/nullif(sum(case when predicted_tp_freq > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_tp_freq_aug18 {
    type: number
    sql: sum(predicted_tp_freq_aug18*evy)/nullif(sum(case when predicted_tp_freq_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_tp_freq_jul19cred {
    type: number
    sql: sum(predicted_tp_freq_jul19cred*evy)/nullif(sum(case when predicted_tp_freq_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_tp_sev_resv3 {
    type: number
    sql: sum(predicted_tp_sev*evy)/nullif(sum(case when predicted_tp_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_sev_aug18 {
    type: number
    sql: sum(predicted_tp_sev_aug18*evy)/nullif(sum(case when predicted_tp_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_sev_jul19cred {
    type: number
    sql: sum(predicted_tp_sev_jul19cred*evy)/nullif(sum(case when predicted_tp_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_bc_resv3 {
    type: number
    sql: sum(predicted_tp_freq*predicted_tp_sev*evy)/nullif(sum(case when predicted_tp_freq*predicted_tp_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_bc_aug18 {
    type: number
    sql: sum(predicted_tp_freq_aug18*predicted_tp_sev_aug18*evy)/nullif(sum(case when predicted_tp_freq_aug18*predicted_tp_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_tp_bc_jul19cred {
    type: number
    sql: sum(predicted_tp_freq_jul19cred*predicted_tp_sev_jul19cred*evy)/nullif(sum(case when predicted_tp_freq_jul19cred*predicted_tp_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_freq_resv3 {
    type: number
    sql: sum(predicted_pi_freq*evy)/nullif(sum(case when predicted_pi_freq > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_pi_freq_aug18 {
    type: number
    sql: sum(predicted_pi_freq_aug18*evy)/nullif(sum(case when predicted_pi_freq_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_pi_freq_jul19cred {
    type: number
    sql: sum(predicted_pi_freq_jul19cred*evy)/nullif(sum(case when predicted_pi_freq_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: percent_1
  }

  measure: pred_pi_sev_resv3 {
    type: number
    sql: sum(predicted_pi_sev*evy)/nullif(sum(case when predicted_pi_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_sev_aug18 {
    type: number
    sql: sum(predicted_pi_sev_aug18*evy)/nullif(sum(case when predicted_pi_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_sev_jul19cred {
    type: number
    sql: sum(predicted_pi_sev_jul19cred*evy)/nullif(sum(case when predicted_pi_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_bc_resv3 {
    type: number
    sql: sum(predicted_pi_freq*predicted_pi_sev*evy)/nullif(sum(case when predicted_pi_freq*predicted_pi_sev > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_bc_aug18 {
    type: number
    sql: sum(predicted_pi_freq_aug18*predicted_pi_sev_aug18*evy)/nullif(sum(case when predicted_pi_freq_aug18*predicted_pi_sev_aug18 > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure: pred_pi_bc_jul19cred {
    type: number
    sql: sum(predicted_pi_freq_jul19cred*predicted_pi_sev_jul19cred*evy)/nullif(sum(case when predicted_pi_freq_jul19cred*predicted_pi_sev_jul19cred > 0 then evy else 0 end),0) ;;
    value_format_name: gbp_0
  }

  measure:  pi_xs_100k_freq{
    type: number
    sql: sum(case when pi_incurred>=100000 then 1 else 0 end)/nullif(${exposure},0) ;;
    value_format: "0.0000%"

  }

  measure:  pi_xs_1m_freq{
    type: number
    sql: sum(case when pi_incurred>=1000000 then 1 else 0 end)/nullif(${exposure},0) ;;
    value_format: "0.0000%"

  }

  measure:  pi_xs_100k_count{
    type: number
    sql: sum(case when pi_incurred>=100000 then 1 else 0 end) ;;


  }

  measure:  pi_xs_1m_count{
    type: number
    sql: sum(case when pi_incurred>=1000000 then 1 else 0 end) ;;


  }


  measure:  pi_xs_50k_freq{
    type: number
    sql: sum(case when pi_incurred>=50000 then 1 else 0 end)/nullif(${exposure},0) ;;
    value_format: "0.0000%"

  }

  measure:  pi_xs_50k_count{
    type: number
    sql: sum(case when pi_incurred>=50000 then 1 else 0 end) ;;


  }


  measure:  predicted_loss_ratio{
    type: number
    sql: avg(predicted_bc)/avg(net_premium) ;;


  }

  }
