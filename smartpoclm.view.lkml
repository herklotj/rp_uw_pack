view: smartpoclm {derived_table: {
    sql:
select
  exposure.*
  ,case when journeys.week_end > to_date(sysdate) then 'Partial Week' else 'Full Week' end as Partial_Week_Flag
  ,ra.postal_area
  ,ra.postal_region
  ,(exposure.week_end - exposure.week+1)*device_Live as device_days
  ,journeys.journeys
  ,journeys.gps_distance
  ,journeys.can_distance
  ,journeys.harsh_acc_count
  ,journeys.harsh_dec_count
  ,journeys.overspeed_count
from
  v_smart_b_live_weekly exposure
left join
    (select
        uid
        ,cal.start_date as week
        ,cal.end_date as week_end
        ,count(*) as journeys
        ,sum(gps_distance) as gps_distance
        ,sum(can_distance) as can_distance
        ,sum(harsh_acc_count) as harsh_acc_count
        ,sum(harsh_dec_count) as harsh_dec_count
        ,sum(overspeed_count) as overspeed_count

     from
        si_journey_summary j
     left join
           aauser.calendar_week cal
          on cal.start_date <= j.start_time and cal.end_date >= j.start_time
     group by uid, cal.start_date,cal.end_date
      )journeys
    on exposure.uid=journeys.uid and journeys.week = exposure.week
  left join
    rated_areas ra
    on replace(exposure.member_home_postcode,' ','')=ra.postcode
     ;;
  }


    dimension: Journey_Week {
      type: date_week
      sql:  ${TABLE}.week ;;
    }

    dimension: member_age{
      type: tier
      tiers: [30,50,65,80]
      style: integer
      sql: ${TABLE}.member_age;;
  }

    dimension: Postcode_Area {
      type: string
      sql: postal_area ;;
    }

    dimension: Postcode_region {
      type: string
      sql: postal_region ;;

    }

    dimension: Partial_Week {
      type: string
      sql: Partial_Week_Flag ;;
    }

    measure: devices_live {
      type:  number
      sql: sum(device_live) ;;

    }

    measure: device_days {
      type: number
      sql: sum(device_days*1.0000) ;;

    }

    measure: journeys {
      type: number
      sql:sum(journeys*1.0000) ;;
    }

    measure: journeys_per_day {
      type: number
      sql: ${journeys}/${device_days} ;;
      value_format_name: decimal_1
    }

   measure: distance_per_day {
     type: number
     sql: sum(gps_distance)/(1000*${device_days}) ;;
     value_format_name: decimal_0
   }

  }
