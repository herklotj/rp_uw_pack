view: expoclm {
  derived_table: {
    sql:
    SELECT
        *,
        riskpremium_an/predicted_market_price AS market_ratio,
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
      end as predicted_bc,
      case when acc_quarter < '2019-01-01' then 'Pre 2019'
             when acc_quarter < '2020-01-01' then '2019'
             when acc_quarter < '2020-04-01' then '2020 1)Pre-lockdown'
             when acc_quarter < '2020-07-01' then '2020 2)Lockdown'
             when acc_quarter < '2020-09-01' then '2020 3)Post-Lockdown'
             when acc_quarter < '2021-01-01' then '2020 4)Second-Wave'
            when acc_quarter  < '2022-01-01' then '2021 5)Lockdown'
             else 'Other'
            end as Covid_Periods,

       case
             when acc_quarter < '2020-03-01' then '1)Pre-covid'
             when acc_quarter < '2021-04-01' then '2) Covid mar20-apr21'
             when acc_quarter >= '2021-04-01' then '3)Post-Covid'
             else 'Other'
            end as Covid_Periods_2,

        case when termincep <= '2017-06-30' then 'XoL Period 1 01/2016 to 06/2017'
              when termincep <= '2018-06-30' then 'XoL Period 2 07/2017 to 06/2018'
              when termincep <= '2018-12-31' then 'XoL Period 3 07/2018 to 12/2018'
              when termincep <= '2019-12-31' then 'XoL Period 4 01/2019 to 12/2019'
              when termincep <= '2020-12-31' then 'XoL Period 5 01/2020 to 12/2020'
              else 'Unknown'
           end as xol_period

        , case when termincep <= '2017-06-30' then 0.083*eprem
               when termincep <= '2018-06-30' then 0.129*eprem
               when termincep <= '2018-12-31' then 0.125*eprem
               when termincep <= '2019-12-31' then 0.125*eprem
               when termincep <= '2020-12-31' then 0.153*eprem
              else 0
           end as xol_prem
         ,case when total_incurred > 1000000 then total_incurred-1000000
              else 0 end as XoL_Incurred_xs1m,

          CASE WHEN Membership_Selection = 2 then ACHUB_ass_LIVE_MEMBER1
          WHEN Membership_Selection = 3 then ACHUB_add1_LIVE_MEMBER1
          WHEN Membership_Selection = 4 then ACHUB_add1_ass_LIVE_MEMBER1
          ELSE ACHUB_LIVE_MEMBER1 end as LIVE_MEMBER1,

          CASE WHEN Membership_Selection = 2 then ACHUB_ass_HOME_HISTORY1
          WHEN Membership_Selection = 3 then ACHUB_add1_HOME_HISTORY1
          WHEN Membership_Selection = 4 then ACHUB_add1_ass_HOME_HISTORY1
          ELSE  ACHUB_HOME_HISTORY1 end as HOME_HISTORY1,

          CASE WHEN Membership_Selection = 2 then ACHUB_ass_TENURE_CURRENT1
          WHEN Membership_Selection = 3 then ACHUB_add1_TENURE_CURRENT1
          WHEN Membership_Selection = 4 then ACHUB_add1_ass_TENURE_CURRENT1
          else ACHUB_TENURE_CURRENT1 end as TENURE_CURRENT1,

          CASE WHEN no_additional_drivers + 1 > 0 THEN INT(MONTHS_BETWEEN (annual_cover_start_dttm_,PH_Residency_Date) / 12) ELSE NULL END AS d1_residency_years,
          CASE WHEN no_additional_drivers + 1 > 1 THEN INT(MONTHS_BETWEEN (annual_cover_start_dttm_,D2_Residency_Date) / 12) ELSE NULL END AS d2_residency_years,
          CASE WHEN no_additional_drivers + 1 > 2 THEN INT(MONTHS_BETWEEN (annual_cover_start_dttm_,D3_Residency_Date) / 12) ELSE NULL END AS d3_residency_years,
          CASE WHEN no_additional_drivers + 1 > 3 THEN INT(MONTHS_BETWEEN (annual_cover_start_dttm_,D4_Residency_Date) / 12) ELSE NULL END AS d4_residency_years


    FROM
      (
      SELECT
            e.polnum,
            e.add_match,
            e.delphi_score,
            e.scheme_number,
            e.scheme,
            e.evy,
            mi.quote_dttm,
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
            e.achub_ass_tenure_current1,
            e.achub_add1_tenure_current1,
            e.achub_add1_ass_tenure_current1,
            e.achub_tenure_current1,
            e.achub_ass_home_history1,
            e.achub_add1_home_history1,
            e.achub_add1_ass_home_history1,
            e.achub_home_history1,
            e.achub_ass_live_member1,
            e.achub_add1_live_member1,
            e.achub_add1_ass_live_member1,
            e.achub_live_member1,
            e.annual_cover_start_dttm_,
            e.TP_Go_Live_Credit_Score,
            e.membership_propensity,
            cov.no_additional_drivers,
            cov.riskpremium_an,
            ra.ad_ra_update,
            ra.tp_ra_update,
            ra.pi_ra_update,
            cov.quote_dttm,
            rreh1_requestdatetime1,
            occupation_type_d1,
            occupation_type_d2,
            occupation_type_d3,
            occupation_type_d4,
            occ.occupation as occupation_desc_d1,
            ba.business_area as business_area_d1,
            occ_cat.Work_Location_Category as Work_Location_Category_d1,
            occ_cat.Occupation_Type_Category as Occupation_Type_Category_d1,

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
            case when timestampdiff (YEAR,dob_d1,rco1_coverstartdate1) >= 70  OR timestampdiff (YEAR,dob_d2,rco1_coverstartdate1) >= 70 OR timestampdiff (YEAR,dob_d3,rco1_coverstartdate1) >= 70 OR timestampdiff (YEAR,dob_d4,rco1_coverstartdate1) >= 70 then 1 else 0 end as age_70_flag,
            case when (f_claims_5yrs + policy_convictions_5yrs >= 1) then 1 else 0 end as claim_conv_1,
            case when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d2 IN ('S', 'W') AND occupation_type_d2 = 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d3 IN ('S', 'W') AND occupation_type_d3 = 'U03')
            AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) AND (occupation_type_d4 != 'U03' OR occupation_type_d4 IS NULL) then 1
            when occupation_type_d1 != 'U03' AND (achub_live_member1 = 'Y' OR achub_add1_live_member1 = 'Y') AND (relationship_d4 IN ('S', 'W') AND occupation_type_d4 = 'U03')
            AND (occupation_type_d3 != 'U03' OR occupation_type_d3 IS NULL) AND (occupation_type_d2 != 'U03' OR occupation_type_d2 IS NULL) then 1      else 0 end as business_rule_2,
            case when f_claims_5yrs = 1 AND policy_convictions_5yrs = 1 then 1 else 0 end as claim_conv_2,
            case when timestampdiff (YEAR,dob_d1,rco1_coverstartdate1) BETWEEN 76 AND 79  OR timestampdiff (YEAR,dob_d2,rco1_coverstartdate1) BETWEEN 76 AND 79 OR timestampdiff (YEAR,dob_d3,rco1_coverstartdate1) BETWEEN 76 AND 79 OR timestampdiff (YEAR,dob_d4,rco1_coverstartdate1) BETWEEN 76 AND 79 then 1 else 0 end as age_79_flag,
            case when e.e0ved1_kcd1_numberpreviouskeepers1 BETWEEN 0 AND 5 then '<= 5' WHEN e.e0ved1_kcd1_numberpreviouskeepers1 = 6 then '06' WHEN e.e0ved1_kcd1_numberpreviouskeepers1 = 7 then '07' WHEN e.e0ved1_kcd1_numberpreviouskeepers1 = 8 then '08' WHEN e.e0ved1_kcd1_numberpreviouskeepers1 = 9 then '09' WHEN e.e0ved1_kcd1_numberpreviouskeepers1 >= 10 then '10+' else 'Unknown' end as previous_keepers,
            timestampdiff (YEAR, veh.e0ved1_rd1_datefirstregistered1, e.exposure_start) as car_age,

            CASE WHEN ACHUB_LIVE_MEMBER1 = 'Y' then 1
            WHEN ACHUB_ass_live_member1 = 'Y' then 2
            WHEN ACHUB_TENURE_CURRENT1 > 0 or ACHUB_HOME_HISTORY1 = 'C' or ACHUB_HOME_HISTORY1 =  'X' then 1
            WHEN cov.no_additional_drivers > 0 and (relationship_d2 = 'S' or relationship_d2 = 'W') AND  ACHUB_add1_live_member1 = 'Y' then 3
            WHEN ACHUB_add1_ass_live_member1 = 'Y' then 4
            WHEN ACHUB_add1_tenure_current1 > 0 or ACHUB_add1_home_history1 = 'C' or ACHUB_add1_home_history1 = 'X' then 3
            ELSE 0 end as Membership_Selection,

            CASE WHEN cov.no_additional_drivers = 0 then 1
            WHEN cov.no_additional_drivers = 1 AND relationship_d2 = 'S' then 1
            WHEN cov.no_additional_drivers = 1 AND relationship_d2 = 'W' then 1
            ELSE 0 end as restriction_derived_br,

            CASE WHEN ( SUBSTRING(REPLACE(UPPER(postcode),' ',''),1,LENGTH(REPLACE(UPPER(postcode),' ','')) - 2) ) IN ('B11','B12','B13','B100','B109','B111','B112','B113','B114','B119','B120','B128','B129','B130','B133','B138','B139','B144','B145','B146','B147','B151','B152','B153','B160','B166','B168','B169','B170','B178','B179','B184','B185','B186','B187','B189','B191','B192','B193','B22','B24','B25','B201','B202','B203','B210','B211','B218','B219','B233','B235','B236','B237','B240','B248','B249','B258','B259','B261','B262','B263','B276','B277','B280','B281','B288','B289','B294','B295','B296','B297','B299','B31','B32','B33','B301','B302','B303','B309','B311','B312','B313','B314','B315','B319','B321','B322','B323','B324','B329','B330','B333','B338','B339','B346','B347','B356','B357','B359','B360','B368','B369','B375','B376','B377','B379','B380','B388','B389','B46','B47','B401','B421','B422','B429','B435','B436','B437','B440','B448','B449','B450','B455','B458','B459','B475','B476','B54','B55','B56','B57','B64','B65','B66','B67','B69','B620','B622','B628','B629','B631','B632','B633','B634','B645','B646','B647','B650','B658','B659','B661','B662','B663','B664','B675','B676','B677','B679','B680','B688','B689','B691','B692','B693','B694','B699','B74','B75','B700','B701','B706','B707','B708','B709','B711','B712','B713','B714','B721','B735','B736','B739','B742','B743','B744','B755','B756','B757','B81','B82','B83','B94','B95','B99','B901','B902','B903','B904','B908','B909','B911','B912','B913','B919','B927','B928','B929','B991','BB11','BB13','BB15','BB16','BB17','BB18','BB19','BB101','BB102','BB111','BB112','BB114','BB119','BB120','BB126','BB21','BB22','BB23','BB24','BB29','BB50','BB51','BB54','BB56','BB80','BB89','BB90','BB94','BB95','BB97','BB98','BB99','BD11','BD12','BD13','BD14','BD15','BD19','BD100','BD108','BD109','BD120','BD146','BD157','BD164','BD175','BD176','BD177','BD181','BD182','BD183','BD184','BD189','BD193','BD194','BD21','BD22','BD23','BD24','BD30','BD37','BD38','BD39','BD40','BD46','BD47','BD48','BD49','BD50','BD55','BD57','BD58','BD59','BD61','BD62','BD63','BD71','BD72','BD73','BD74','BD80','BD87','BD88','BD89','BD94','BD95','BD96','BD971','BD981','BD985','BD988','BD992','BD994','BD999','BL11','BL12','BL13','BL14','BL15','BL16','BL17','BL18','BL19','BL111','BL21','BL22','BL23','BL24','BL25','BL26','BL31','BL32','BL33','BL34','BL35','BL36','BL40','BL44','BL47','BL48','BL49','BL781','BL787','BL81','BL82','BL90','BL95','BL96','BL97','BL98','BL99','CH11','CH12','CH13','CH14','CH15','CH21','CH22','CH23','CH35','CH47','CH48','CH410','CH411','CH412','CH413','CH414','CH415','CH416','CH417','CH418','CH419','CH420','CH421','CH422','CH423','CH424','CH425','CH426','CH427','CH428','CH429','CH430','CH431','CH432','CH433','CH434','CH435','CH436','CH437','CH438','CH439','CH440','CH441','CH442','CH443','CH444','CH445','CH446','CH447','CH448','CH449','CH450','CH451','CH452','CH453','CH454','CH455','CH456','CH457','CH458','CH459','CH650','CH651','CH652','CH653','CH654','CH655','CH656','CH657','CH658','CH659','CH661','CH662','CH663','CH664','CH883','CH991','CH999','FY01','FY11','FY12','FY13','FY14','FY15','FY16','FY19','FY20','FY29','FY37','FY38','FY39','FY41','FY42','FY43','FY44','FY45','FY49','HX11','HX12','HX13','HX14','HX15','HX19','HX30','L10','L11','L12','L13','L14','L15','L16','L17','L18','L19','L100','L101','L102','L103','L104','L105','L106','L107','L108','L109','L110','L111','L112','L113','L114','L115','L116','L117','L118','L119','L120','L121','L122','L123','L124','L125','L126','L127','L128','L129','L130','L131','L132','L133','L134','L135','L136','L137','L138','L139','L140','L141','L142','L143','L144','L145','L146','L147','L148','L149','L150','L151','L152','L153','L154','L155','L156','L157','L158','L159','L160','L161','L162','L163','L164','L165','L166','L167','L168','L169','L170','L171','L172','L173','L174','L175','L176','L177','L178','L179','L180','L181','L182','L183','L184','L185','L186','L187','L188','L189','L190','L191','L192','L193','L194','L195','L196','L197','L198','L199','L20','L21','L22','L23','L24','L25','L26','L27','L28','L29','L200','L201','L202','L203','L204','L205','L206','L207','L208','L209','L210','L211','L212','L213','L214','L215','L216','L217','L218','L219','L220','L221','L222','L223','L224','L225','L226','L227','L228','L229','L230','L231','L232','L233','L235','L236','L237','L238','L239','L240','L241','L242','L243','L244','L245','L246','L247','L248','L249','L250','L251','L252','L253','L254','L255','L256','L257','L258','L259','L260','L261','L262','L263','L264','L265','L266','L267','L268','L269','L270','L271','L272','L273','L274','L275','L276','L277','L278','L280','L281','L283','L284','L285','L286','L287','L288','L30','L31','L32','L33','L34','L35','L36','L37','L38','L39','L300','L301','L302','L303','L304','L305','L306','L307','L308','L309','L310','L312','L313','L315','L316','L317','L318','L319','L320','L321','L322','L323','L324','L325','L326','L327','L328','L329','L360','L361','L362','L363','L364','L365','L366','L367','L368','L369','L371','L372','L373','L374','L376','L377','L378','L391','L392','L393','L394','L395','L40','L41','L42','L43','L44','L45','L46','L47','L48','L49','L50','L51','L52','L53','L54','L55','L56','L57','L58','L59','L60','L61','L62','L63','L64','L65','L66','L67','L68','L69','L671','L680','L691','L692','L693','L694','L695','L696','L697','L698','L699','L70','L71','L72','L73','L74','L75','L76','L77','L78','L79','L701','L702','L708','L709','L712','L720','L721','L728','L736','L744','L751','L752','L80','L81','L82','L83','L84','L85','L86','L87','L88','L89','L804','L90','L91','L92','L93','L94','L95','L96','L97','L98','L99','M11','M12','M13','M14','M15','M16','M17','M110','M111','M112','M113','M114','M120','M124','M125','M126','M130','M131','M139','M140','M144','M145','M146','M147','M154','M155','M156','M160','M166','M167','M168','M169','M171','M178','M187','M188','M190','M191','M192','M193','M21','M22','M23','M24','M25','M26','M27','M201','M202','M203','M204','M205','M206','M210','M213','M217','M218','M219','M220','M221','M222','M223','M224','M225','M228','M229','M230','M231','M232','M239','M240','M241','M242','M244','M245','M246','M250','M251','M252','M253','M259','M270','M274','M275','M276','M278','M279','M31','M32','M33','M34','M35','M36','M37','M300','M303','M307','M308','M309','M314','M320','M322','M328','M329','M340','M342','M343','M345','M346','M347','M350','M355','M359','M41','M42','M43','M44','M45','M46','M47','M400','M401','M402','M403','M404','M405','M407','M408','M409','M430','M436','M437','M450','M456','M457','M458','M50','M53','M54','M55','M501','M502','M503','M509','M65','M66','M67','M68','M600','M601','M602','M603','M604','M606','M607','M608','M609','M610','M71','M72','M73','M74','M80','M81','M82','M84','M85','M88','M89','M90','M94','M95','M96','M97','M98','M99','M901','M902','M903','M904','M905','M991','M992','OL11','OL12','OL13','OL14','OL19','OL111','OL112','OL113','OL114','OL115','OL120','OL126','OL127','OL161','OL162','OL163','OL164','OL165','OL169','OL25','OL26','OL27','OL28','OL41','OL42','OL60','OL66','OL67','OL68','OL69','OL70','OL79','OL81','OL82','OL83','OL84','OL90','OL96','OL97','OL98','OL99','OL951','PR02','PR10','PR11','PR12','PR13','PR14','PR15','PR16','PR17','PR18','PR19','PR20','PR21','PR22','PR23','PR26','PR27','PR28','PR29','PR60','PR66','PR71','PR72','PR73','PR81','PR82','PR83','PR84','PR86','PR89','PR90','PR97','PR99','S701','S702','SK11','SK12','SK13','SK14','SK19','SK101','SK102','SK103','SK116','SK117','SK118','SK25','SK26','SK27','SK29','SK30','SK33','SK38','SK39','SK41','SK42','SK43','SK44','SK45','SK49','SK56','SK57','SK58','SK59','WA11','WA12','WA13','WA14','WA19','WA101','WA102','WA103','WA104','WA105','WA106','WA109','WA20','WA27','WA29','WA41','WA42','WA50','WA51','WA52','WA53','WA57','WA58','WA59','WA551','WA71','WA72','WA74','WA75','WA76','WA79','WA84','WA86','WA87','WA89','WA881','WA91','WA92','WA93','WF101','WF103','WF104','WF105','WF118','WF61','WF81','WF82','WF84','WN11','WN12','WN13','WN19','WN22','WN34','WN35','WN36','WN50','WN58','WN59','WN67','WN71','WN72','WN73','WN74','WN75','WN79','WN86','WN88','WN89') THEN 'DECLINE'
            ELSE 'ACCEPT' END AS Postcode_Sector_Decline,

            CASE WHEN rpr1_rd1_residencydate1 IS NULL THEN dob_d1 ELSE rpr1_rd1_residencydate1 END AS PH_Residency_Date,
            CASE WHEN ad1_dd1_rd1_residencydate1 IS NULL THEN dob_d2 ELSE ad1_dd1_rd1_residencydate1 END AS D2_Residency_Date,
            CASE WHEN ad2_dd1_rd1_residencydate1 IS NULL THEN dob_d3 ELSE ad2_dd1_rd1_residencydate1 END AS D3_Residency_Date,
            CASE WHEN ad3_dd1_rd1_residencydate1 IS NULL THEN dob_d4 ELSE ad3_dd1_rd1_residencydate1 END AS D4_Residency_Date,
            mi.rct_mi_14 AS predicted_market_price,

            CASE WHEN e4q02 IN (2, 3, 4, 5) AND e4q17!= 6 AND E0BUMK1_MatchCategory1 IN ('1a', '1b') then 'Expanded_Footprint' else 'Core_Footprint' end as br62_ftp_expansion_flag

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
              rated_area_update ra
              on ra.postcode_sector = left(replace(e.postcode,' ',''),length(replace(e.postcode,' ',''))-2)
         left join
              qs_cover cov
              on e.quote_id = cov.quote_id AND e.quote_id != ' ' AND to_date(cov.quote_dttm) != '2999-12-31' AND e.quote_id IS NOT NULL
         left join
              qs_experian_vehicle veh
              on e.quote_id = veh.quote_id AND e.quote_id != ' ' AND e.quote_id IS NOT NULL
         left join
              (select LPAD(abi_code,3,0) as abi_code , occupation from abi_occupation) occ
              ON e.occupation_type_d1 = occ.abi_code
         left join
              abi_business_area ba
              on e.employers_business_d1 = ba.abi_code
         left join
              occupation_category_lookup occ_cat
              on occ_cat.Occ_ABI_Code = e.occupation_type_d1
          left join
              qs_mi_outputs mi
              ON e.quote_id = mi.quote_id AND e.quote_id != ' ' AND to_date(mi.quote_dttm) != '2999-12-31' AND e.quote_id IS NOT NULL AND mi.rct_mi_14 != ' '

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

  dimension: XoL_Period {
    type:  string
    sql:  ${TABLE}.xol_period ;;
  }

  dimension: Accident_Quarter {
    type: date_quarter
    sql: ${TABLE}.acc_quarter ;;

  }

  dimension: Covid_Periods {
    type: string
    sql: ${TABLE}.covid_periods;;
  }

  dimension: Covid_Periods_2 {
    type: string
    sql: ${TABLE}.covid_periods_2;;
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

  dimension: new_market_model {
    type: string
    sql:CASE
         WHEN inception_strategy = '26: Aug18' AND to_date (quote_dttm) > '2021-04-20' AND to_date (quote_dttm) != '2999-12-31' AND to_date (quote_dttm) IS NOT NULL THEN 'NEW (26)'
         WHEN inception_strategy = '32: NM Jul18 - New Margin' AND to_date (quote_dttm) >= '2021-04-28' AND to_date (quote_dttm) != '2999-12-31' AND to_date (quote_dttm) IS NOT NULL THEN 'NEW (32)'
         WHEN to_date(quote_dttm) >= '2021-05-14' AND inception_strategy = '33: M July19' THEN 'NEW (33)'
         WHEN to_date(quote_dttm) >= '2021-05-21'  AND inception_strategy = '35: NM July 19' THEN 'NEW (35)'
         ELSE 'OLD'
       END;;
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

  dimension: market_ratio_bands {
    type: tier
    tiers: [0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5]
    style: interval
    sql: ${TABLE}.market_ratio ;;
    value_format_name: decimal_2
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
    tiers: [0, 1, 2, 3, 6, 9]
    style: integer
    sql: ${TABLE}.ncd_years ;;
  }

  dimension: ncd_years_9plus {
    label: "NCD Years 9+"
    type: string
    sql: case when ${TABLE}.ncd_years >=9 then '9+' else ${TABLE}.ncd_years end;;
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



  dimension: claims_conv_70_plus_bs{
    type: number
    sql:  case when age_70_flag = 1 AND claim_conv_1 = 1 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' then 1 else 0 end ;;
    description: "Allowing where there is a fault claim / conviction on the policy and an aged 70+ driver providing the aged 70+ is not the driver with claim / conviction (scheme 102 & 103)"
  }

  dimension: occupation_bs{
    type: number
    sql:  case when business_rule_2 = 1 AND scheme_number = 102 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' then 1 else 0 end ;;
    description: "Allowing unemployed partners / spouses where the PH is employed and a live member"
  }

  dimension: claims_conv_103{
    type: number
    sql:  case when to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' AND claim_conv_2 = 1 AND scheme_number = 103 then 1 else 0 end ;;
    description: "Allowing a policy with a fault claim and conviction providing they are on different drivers (scheme 103)"
  }

  dimension: claims_conv_102{
    type: number
    sql:  case when to_date(rreh1_requestdatetime1) >= '2019-02-06' AND transaction_type = 'New Business' AND claim_conv_2 = 1 AND scheme_number = 102 then 1 else 0 end ;;
  }


  dimension: max_age_bs{
    type: number
    sql:  case when age_79_flag = 1 AND to_date(rreh1_requestdatetime1) >= '2020-04-24' AND transaction_type = 'New Business' AND scheme_number = 103 then 1 else 0 end ;;
    description: "Allowing up to 79 year olds with no fault claims or convictions (scheme 103)"
  }

  dimension: max_age_bs_102{
    type: number
    sql:  case when age_79_flag = 1  AND transaction_type = 'New Business' AND scheme_number = 102 then 1 else 0 end ;;
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

  dimension: number_previous_keepers {
    type: string
    sql: previous_keepers ;;
  }

  dimension: car_age {
    type: number
    sql: car_age ;;
  }


  dimension: occupation_d1 {
    type: string
    sql: occupation_type_d1 ;;
  }

  dimension: occupation_desc_d1 {
    type: string
    sql: occupation_desc_d1 ;;
  }

  dimension: business_area_d1 {
    type: string
    sql: business_area_d1 ;;
  }

  dimension:  Occupation_Location_Category_d1 {
    type: string
    sql:  Work_Location_Category_d1 ;;
  }

  dimension: Occupation_Type_Category_d1 {
    type: string
    sql: Occupation_Type_Category_d1 ;;
  }


  dimension: Membership_Type {
    type: string
    sql: CASE WHEN ${TABLE}.LIVE_MEMBER1 = 'N' and ${TABLE}.HOME_HISTORY1!= 'C' and ${TABLE}.HOME_HISTORY1!=  'X' and ${TABLE}.TENURE_CURRENT1 > 0 then 'Ex-Member'
         WHEN ${TABLE}.LIVE_MEMBER1 = 'N' and (${TABLE}.HOME_HISTORY1 = 'C' or ${TABLE}.HOME_HISTORY1 = 'X') then 'Non Member Home'
         WHEN ${TABLE}.LIVE_MEMBER1 = 'Y' then 'Standard Member'
         WHEN ${TABLE}.LIVE_MEMBER1 = 'N' then 'Other Non Member'
         ELSE 'Unknown' end;;
  }

  dimension: footprint_br03 {
    type: string
    sql: CASE WHEN ${TABLE}.Postcode_Sector_Decline = 'DECLINE' AND ${Membership_Type} = 'Standard Member' then 'irrelevant'
         WHEN ${TABLE}.Postcode_Sector_Decline = 'DECLINE' AND ${TABLE}.ncd_years > 2 and restriction_derived_br = 1 then 'IoD/IS_Only'
         WHEN ${TABLE}.Postcode_Sector_Decline = 'DECLINE' AND ${TABLE}.ncd_years > 2 then 'Other_Driving_Restriction - FTP'
         else 'irrelevant' end ;;
  }

  dimension: ncd_greater_than_licence_years_flag {
    type: string
    sql: CASE WHEN ${TABLE}.ncd_years - (timestampdiff (YEAR,${TABLE}.rpr1_mld1_licencequalifyingdate1 - 1,rco1_coverstartdate1)) = 1 THEN 'Yes - FTP' ELSE 'No' END ;;
  }

  dimension: min_driver_residency_years {
    type: string
    sql: CASE WHEN LEAST(${TABLE}.d1_residency_years,${TABLE}.d2_residency_years,${TABLE}.d3_residency_years,${TABLE}.d4_residency_years) >= 10 AND LEAST(${TABLE}.d1_residency_years,${TABLE}.d2_residency_years,${TABLE}.d3_residency_years,${TABLE}.d4_residency_years) < 15 THEN '2) 10-14 - FTP'
         WHEN LEAST(${TABLE}.d1_residency_years,${TABLE}.d2_residency_years,${TABLE}.d3_residency_years,${TABLE}.d4_residency_years) >= 15 THEN '3) 15+'
         ELSE '1) 9 or less'END ;;
  }

  dimension: car_value {
    type: string
    sql: CASE WHEN ${TABLE}.value < 500 THEN '1) £0 - £499 - FTP'
         WHEN ${TABLE}.value BETWEEN 500 AND 999 THEN '2) £500 - £999'
         WHEN ${TABLE}.value BETWEEN 1000 AND 1999 THEN '3) £1000 - £1999'
         ELSE '4) £2000 +' END ;;
  }

  dimension: tp_credit_score_restriction {
    type: string
    sql: CASE WHEN ${TABLE}.TP_Go_Live_Credit_Score > 0.0329 then 'New Accept' else 'Old Accept' end ;;
  }

  dimension: ncd_years_unbanded {
    type: number
    sql: ${TABLE}.ncd_years ;;
  }

  dimension: low_ncd_rule {
    type: string
    sql: CASE WHEN (restriction_derived_br!= 0 AND pi_rated_area < 50) AND f_claims_5yrs = 0 then 'Old Rule' else 'Relaxed Rule - FTP' end ;;
  }

  dimension: BR62_FTP_expansion {
    type: string
    sql:  ${TABLE}.br62_ftp_expansion_flag ;;
  }

  dimension: membership_propensity {
    type: string
    sql: CASE WHEN membership_propensity >= 0.015 AND membership_propensity < 0.02 then '1) 0.015-0.02'
WHEN membership_propensity >= 0.02 AND membership_propensity < 0.025 then '2) 0.020-0.025'
WHEN membership_propensity >= 0.025 AND membership_propensity < 0.03 then '3) 0.025-0.030'
WHEN membership_propensity >= 0.03 AND membership_propensity < 0.035 then '4) 0.030-0.035'
WHEN membership_propensity >= 0.035 then '5) >= 0.035'
ELSE 'Other' end ;;
  }

# Measures

  measure: exposure {
    type: sum
    sql: ${TABLE}.evy ;;
    value_format: "#,##0"
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
    sql: sum(case when pi_incurred>=100000 then 1.00000 else 0.00000 end)/(nullif(${exposure},0.000))*1.000 ;;
    value_format: "0.0000%"
  }

  measure:  pi_xs_1m_freq{
    type: number
    sql: sum(case when pi_incurred>=1000000 then 1.00000 else 0.00000 end)/nullif(${exposure},0) ;;
    value_format: "0.0000%"
  }

  measure:  pi_xs_100k_count{
    type: number
    sql: sum(case when pi_incurred>=100000 then 1.00000 else 0.00000 end) ;;
  }

  measure:  pi_xs_1m_count{
    type: number
    sql: sum(case when pi_incurred>=1000000 then 1 else 0 end) ;;
  }


  measure:  pi_xs_50k_freq{
    type: number
    sql: sum(case when pi_incurred>=50000 then 1.00000 else 0.00000 end)/nullif(${exposure},0) ;;
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


  measure:  XoL_Earned_Premium{
    type: number
    sql: sum(xol_prem) ;;
    value_format_name: gbp_0
  }

  measure: XoL_Incurred_XS1m {
    type:  number
    sql:  sum (XoL_Incurred_XS1m) ;;
    value_format_name: gbp_0
  }

  measure: XoL_Loss_Ratio {
    type:  number
    sql: sum(xol_incurred_xs1m)/sum(xol_prem) ;;
    value_format_name: percent_0
  }

  measure: XoL_Claims_Count {
    type: number
    sql: sum(case when XoL_incurred_XS1m > 0 then 1 else 0 end) ;;
  }

  measure: XoL_XS1m_Freq {
    type: number
    sql: sum(case when XoL_incurred_XS1m > 0 then 1000.0000000 else 0.0000000 end)/1000.00000/nullif(${exposure},0) ;;
    value_format: "0.0000%"
  }

  measure: XoL_Rate_Earned {
    type: number
    sql: ${XoL_Earned_Premium}/${earned_premium} ;;
    value_format_name: percent_2
  }

  measure: Record_count {
    type: count
  }

}
