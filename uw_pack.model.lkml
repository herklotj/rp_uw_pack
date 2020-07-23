connection: "echo_aapricing"

# include all the views
include: "*.view"

datagroup: uw_pack_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: uw_pack_default_datagroup

explore: expoclm {}
