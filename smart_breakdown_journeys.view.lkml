view: smart_breakdown_journeys {derived_table: {
    sql:
    select
      start_time
      ,UID
      ,year(start_time) as year
      ,month(start_time) as month
      ,week(start_time) as week_number
      ,dayofweek(start_time) as week_day
      ,hour(start_time) as start_hour
      ,1 as journey
      ,gps_distance
      ,CASE WHEN to_date(start_time) < '2019-01-01' then '01) pre-2019'
WHEN to_date(start_time) >= '2019-01-01' AND to_date(start_time) <= '2019-12-31' then '02) 2019'
WHEN to_date(start_time) >= '2020-01-01' AND to_date(start_time) <= '2020-03-23' then '03) pre-2020-lockdown (Jan-Mar 20)'
WHEN to_date(start_time) >= '2020-03-24' AND to_date(start_time) <= '2020-07-03' then '04) first_lockdown (Mar-Jul 20)'
WHEN to_date(start_time) >= '2020-07-04' AND to_date(start_time) <= '2020-11-04' then '05) post-lockdown (Jul-Nov 20)'
WHEN to_date(start_time) >= '2020-11-05' AND to_date(start_time) <= '2020-12-01' then '06) second_lockdown (Nov-Dec 20)'
WHEN to_date(start_time) >= '2020-12-02' AND to_date(start_time) <= '2021-01-05' then '07) christmas_period (Dec-Jan 21)'
WHEN to_date(start_time) >= '2021-01-06' AND to_date(start_time) <= '2021-03-07' then '08) third_2021_lockdown (Jan-Mar 21)'
WHEN to_date(start_time) >= '2021-03-08' AND to_date(start_time) <= '2021-04-11' then '09) stage1_relaxation (Mar-Apr 21)'
WHEN to_date(start_time) >= '2021-04-12' AND to_date(start_time) <= '2021-05-16' then '10) stage2_relaxation (Apr-May 21)'
WHEN to_date(start_time) >= '2021-05-17' AND to_date(start_time) <= '2021-06-20' then '11) stage3_relaxation (May-Jun 21)'
WHEN to_date(start_time) >= '2021-06-21' then '12) lockdown_end' else 'Unknown' end as Covid_Periods
    from
      si_journey_summary
     ;;
  }



  dimension_group: Journey_Date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:  ${TABLE}.start_time ;;
  }

  dimension: Day_Of_week {
    type: number
    sql: dayofweek(start_time);;
  }

  dimension: Time_Of_Day {
    type: number
    sql:case when month(start_time) <=3 then hour(${TABLE}.start_time)
                 when month(start_time) <=10 then hour(${TABLE}.start_time)+1
                 else hour(${TABLE}.start_time) end
             ;;
  }

  dimension: Covid_Period {
    type: string
    sql: ${TABLE}.covid_periods ;;
  }

  measure: Journeys {
    type: count
  }

  measure: distance {
    type: number
    sql: sum(gps_distance) ;;
  }

}
