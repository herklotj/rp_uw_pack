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
      ,case when start_time < '2019-01-01' then 'Pre 2019'
             when start_time < '2020-01-01' then '2019'
             when start_time < '2020-04-01' then '2020 1)Pre-lockdown'
             when start_time < '2020-07-01' then '2020 2)Lockdown'
             when start_time < '2020-09-01' then '2020 3)Post-Lockdown'
             when start_time < '2021-01-01' then '2020 4)Second-Wave'
             else 'Other'
            end as Covid_Periods
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
      sql: hour(${TABLE}.start_time) ;;
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
