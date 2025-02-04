# WARNING - Generated by {fusen} from dev/flat_get-deprivation-data-for-parishes.Rmd: do not edit by hand

#' @noRd
cached_imd_data <- function(){
  .coedata_envir$parish_imd_2019
}

#' Get parish-level deprivation data from the Church of England
#' 
#' coe_parish_deprivation and coe_parish_imd are the same function
#'
#' @rdname coe_parish_deprivation
#' @param parish_codes Character vector of parish codes to return. The default (TRUE) returns all parish codes.
#' @param domains Logical. Should individual domains of deprivation be included?
#' @param subdomains Logical. Should subdomains be included?
#' @param supplementary Logical. Should supplementary statistics be included?
#' 
#' @returns A tibble of deprivation data with one row per parish.
#'  
#' @export
#' @examples
#' coe_parish_deprivation("350259")
#'
#' coe_parish_deprivation("350259", domains = TRUE)

coe_parish_deprivation <- function(parish_codes = TRUE, domains = FALSE, subdomains = FALSE, supplementary = FALSE){
  
  assertthat::is.flag(domains)
  assertthat::is.flag(subdomains)
  assertthat::is.flag(supplementary)
  
  out <- read_imd_data()
  
  imd_names <- names(out)
  
  core_names <- which(imd_names %in% c("parish_code", "parish_name", "imd_score", 
                                      "imd_rank", "imd_rank_decile", "imd_rank_percentile"))
  
  subdomain_names    = grep("sub_domain", imd_names)
  supplementary_names = grep("supplementary", imd_names)
  
  
  all_names <- 1:length(imd_names)
  domain_names <- all_names[!all_names %in% c(core_names, subdomain_names, supplementary_names)]
  
  included_names <- c(core_names, subdomain_names[subdomains], supplementary_names[supplementary],
                      domain_names[domains])
  
  included_names <- all_names[all_names %in% included_names]
  
  class(out) <- c("coe_parish_data_imd", class(out))
  
  if(!assertthat::is.flag(parish_codes)) out <- out[included_names][out$parish_code %in% parish_codes,]
  
  out
}


#' @noRd
get_imd_sheet <- \() get_cpd_sheet("1fWr1MIbovWJKo8AEx5On6QuJe1Eqnn98mI5LQ3uq6qs", "imd")

#' @noRd
read_imd_data <- function(){
  
  if(is.null(cached_imd_data())){
    
    imd_data <- get_imd_sheet()
    .coedata_envir$parish_imd_2019 <- imd_data
    
  }
  
  cached_imd_data()
  
}
