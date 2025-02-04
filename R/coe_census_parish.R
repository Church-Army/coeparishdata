# WARNING - Generated by {fusen} from dev/flat_reading-coe-statistics.Rmd: do not edit by hand

#' Obtain parish-level census statistics on a given topic 
#' 
#' @param ons_id The ONS id the required topic
#' @param parish_codes Parish codes of required parishes. If empty (the default) data for all parishes are returned.
#' @param ... Other arguments passed to [coe_census()]
#' 
#' @export 
#' @examples
#' coe_census_parish(ons_id = "TS062", parish_codes = "350041", relative = TRUE)
coe_census_parish <- function(ons_id, parish_codes, ...){
  
  if(!rlang::is_missing(parish_codes)) out <- coe_census(ons_id, level = "parish", areas = parish_codes, ...)
  else out <- coe_census(ons_id, level = "parish", ...)
  out
}
