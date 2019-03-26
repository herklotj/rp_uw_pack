connection: "echo_aapricing"

# include all the views
include: "*.view"

datagroup: uw_pack_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: uw_pack_default_datagroup

explore: expoclm {}

# - explore: accident_years

# - explore: breakdown_rpm

# - explore: broker_motor_sales

# - explore: broker_sales

# - explore: car_genie_devices

# - explore: cf_broker_policy_voids

# - explore: cma_2018_nb

# - explore: cma_2018_ren

# - explore: cma_2018_xq

# - explore: conf_23to25s

# - explore: conf_members_2018_breakdowns

# - explore: conf_members_2018_qts

# - explore: conf_members_2018_sales

# - explore: conf_mkt_prem

# - explore: cue_last_run

# - explore: dist_102_resv3_vs_aug18

# - explore: ec

# - explore: expoclm_103

# - explore: expoclm_aug

# - explore: expoclm_quarters

# - explore: expoclm_quarters_holdout

# - explore: expoclm_quarters_sample

# - explore: expoclm_sample

# - explore: expoclm_vehicle_info

# - explore: fca_2016_samp_pols

# - explore: fca_2016_sampling

# - explore: fca_2017_samp_pols

# - explore: fca_2017_sampling

# - explore: fca_2018_samp_pols

# - explore: fca_2018_sampling

# - explore: fca_samp_pols

# - explore: financial_years

# - explore: jack_market_test

# - explore: jack_radar_export_conf

# - explore: jack_reg_test

# - explore: ln_discrepencies

# - explore: lr_dist_102_aug18_scores

# - explore: lr_dist_102_resv3_scores

# - explore: mem_prop_for_radar

# - explore: missing_acx_factors

# - explore: missing_ins_factors

# - explore: ml_conf

# - explore: ml_conf_join

# - explore: ml_conf_pred_response

# - explore: model_calibration

# - explore: model_calibration_aug18

# - explore: model_calibration_jul18

# - explore: model_calibration_summary

# - explore: model_calibration_summary_aug18

# - explore: model_calibration_summary_jul18

# - explore: mot_history

# - explore: mot_lead

# - explore: mot_test_item_2016

# - explore: mot_test_result_2016

# - explore: net_gross_lr_dist_aug18

# - explore: pattern_to_ultimate

# - explore: policy_extract_control_temp

# - explore: policy_slots_prelim

# - explore: postcode_sector_declines

# - explore: profile_comp_prelim

# - explore: profile_comp_prelim_model

# - explore: qre_numbers

# - explore: qs_correlation_correction

# - explore: r_mi_temp

# - explore: radar_channel

# - explore: radar_exort_conf_aug

# - explore: radar_exort_conf_oct

# - explore: radar_exort_conf_sep

# - explore: radar_export

# - explore: radar_export_conf

# - explore: radar_export_conf_102

# - explore: radar_export_conf_103

# - explore: radar_export_conf_aug

# - explore: radar_export_conf_cue

# - explore: radar_export_conf_cue_sales

# - explore: radar_export_conf_half

# - explore: radar_export_conf_homemember_v2

# - explore: radar_export_conf_schemetemp

# - explore: radar_export_conv_aug

# - explore: radar_export_conv_jul

# - explore: radar_export_hsls

# - explore: radar_export_nb

# - explore: radar_export_rnwls

# - explore: radar_export_rnwls_l3m_nodup

# - explore: radar_export_rnwls_nodup

# - explore: radar_export_sales

# - explore: radar_export_sales_uwy3

# - explore: radar_export_xqts

# - explore: radar_export_xqts_nodup

# - explore: radar_export_xqts_nodup_l12m

# - explore: radar_export_xqts_nodup_l3m

# - explore: radar_export_xqts_nodup_l6m

# - explore: radar_export_xqts_nodup_quoted_l12m

# - explore: radar_export_xqts_nodup_quoted_l3m

# - explore: radar_export_xqts_nodup_quoted_l6m

# - explore: radar_sales_renewalstest

# - explore: radar_tmp_2

# - explore: rapidminer_residuals

# - explore: rdr_gbm_null_constants

# - explore: renewal_radar_mi

# - explore: renewal_radar_mi3

# - explore: t20190313_quotes

# - explore: today

# - explore: uncalibrated_scores

# - explore: uncalibrated_scores_aug18

# - explore: uncalibrated_scores_jul18

# - explore: uncalibrated_scores_nm

# - explore: uncalibrated_scores_toscore

# - explore: uw_years

# - explore: v_aaihl_bc_data

# - explore: v_aap_edipol

# - explore: v_aap_reservebreakdownhistory

# - explore: v_acc_mth_claims

# - explore: v_av_qtd_prem

# - explore: v_avg_settled_distribution

# - explore: v_avg_settled_incurred

# - explore: v_ay_lr_development

# - explore: v_batch_renewals

# - explore: v_canc_at_inception

# - explore: v_canc_development

# - explore: v_cf_case_management

# - explore: v_cf_case_management_current_month

# - explore: v_cf_case_management_ytd

# - explore: v_cf_keeperchange

# - explore: v_cf_lookup

# - explore: v_claim_freq_wk

# - explore: v_claim_status

# - explore: v_claims_cumulative

# - explore: v_claims_cumulative_sum

# - explore: v_claims_latest_position

# - explore: v_claims_monthly_trends

# - explore: v_claims_transactions

# - explore: v_claims_transactions_prelim

# - explore: v_clm_bordereaux_last_2m

# - explore: v_clm_bordereaux_uwy1

# - explore: v_clm_bordereaux_uwy2

# - explore: v_clm_bordereaux_uwy3

# - explore: v_confused_panel_stats

# - explore: v_confused_ratios

# - explore: v_conversion

# - explore: v_conversion_report

# - explore: v_conversion_wk

# - explore: v_cue_discrepancies

# - explore: v_cue_frequency

# - explore: v_daily_averages_mty

# - explore: v_daily_snapshot_headlines

# - explore: v_earned_radar_loss_ratio

# - explore: v_edi_sales_daily

# - explore: v_exp_and_earn_prem

# - explore: v_exp_and_earn_prem_wk

# - explore: v_experian_failures

# - explore: v_factor_lrs

# - explore: v_factor_lrs2

# - explore: v_features_with_chire

# - explore: v_fnol_claims

# - explore: v_fp_change_201902

# - explore: v_freq_tri_rpt

# - explore: v_fy_lr_development

# - explore: v_home_claims_extract

# - explore: v_hourly_qts

# - explore: v_hourly_sales

# - explore: v_ibnr_calcs

# - explore: v_inception_strategy

# - explore: v_incurred_tris

# - explore: v_incurred_tris_all

# - explore: v_inforce_policies

# - explore: v_ln_discrepencies

# - explore: v_ln_quotes_discrepencies

# - explore: v_lr_pricing_stategy_ult

# - explore: v_mi_canc_dev

# - explore: v_mm_v_conf

# - explore: v_motor_renewals_yoy_spread

# - explore: v_mta_by_model

# - explore: v_mta_numbers

# - explore: v_mtd_kpis

# - explore: v_policy_origin

# - explore: v_policy_slots

# - explore: v_policy_slots_prelim

# - explore: v_poq_failures_last_week

# - explore: v_poq_failures_monthly

# - explore: v_prem_earned

# - explore: v_prem_earned_wk

# - explore: v_prem_transactional

# - explore: v_profile_comp

# - explore: v_profile_comp_model

# - explore: v_qre_amounts

# - explore: v_qre_exposure

# - explore: v_qre_numbers

# - explore: v_quarterly_frequency_tris

# - explore: v_quarterly_incurred_tris

# - explore: v_rec_reserves

# - explore: v_recovery_data

# - explore: v_ren_yoys

# - explore: v_renewal_batch

# - explore: v_renewal_competitiveness

# - explore: v_renewal_cover

# - explore: v_renewal_shoppers

# - explore: v_renewal_static_table

# - explore: v_reserving_amounts

# - explore: v_reserving_numbers

# - explore: v_reserving_premium_vectors

# - explore: v_rpt_daily_br

# - explore: v_sales_by_sold_date

# - explore: v_same_day_conversion

# - explore: v_sap_claim_pol

# - explore: v_sap_claim_pol_home

# - explore: v_sap_policy_uwy

# - explore: v_sap_policy_uwy_home

# - explore: v_sboc_history

# - explore: v_scheme

# - explore: v_scheme_detailed

# - explore: v_slrs_aug18

# - explore: v_slrs_new_rm

# - explore: v_slrs_nmjul18

# - explore: v_slrs_resv3

# - explore: v_std_reserves

# - explore: v_strat_conv

# - explore: v_strategy_kpis

# - explore: v_trading_dash

# - explore: v_trading_mi

# - explore: v_trading_stats

# - explore: v_uwy_lr_development

# - explore: v_vehicle_file_nd_update

# - explore: v_vehicle_file_nd_update_uncleansed

# - explore: v_xq_stats

# - explore: vl_flag_manual_test

# - explore: xq_subset
