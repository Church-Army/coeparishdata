# WARNING - Generated by {fusen} from dev/flat_reading-coe-statistics.Rmd: do not edit by hand

# TODO: Add data/function for reading 'parish map'
# TODO: Rbind these tables in a way that makes sense lol
#' Get a (list of) comparative table(s) of local, diocesan and national data for a given parish
#' 
#' Extracts parish, diocese and national level data for a given parish, then [base::rbind]s them into a single table. Iterates over `nomis_codes` to output a list of such tables
#' @returns A list of `coe_parish_data` tibbles
#' @param parish_code A single parish code. Character.
#' @param nomis_codes A character vector of nomis_codes.
#' @param relative Logical. Should outputs be relative? Default is `TRUE`.
#' @export
#' @examples
#' coe_parish_census_context(parish_code = "370047", nomis_codes = "TS001")

coe_parish_census_context <- function(parish_code,
                                  nomis_codes = coe_datasets(description = FALSE),
                                  relative = TRUE){
  
  p_table <- read_parish_table()
  
  nomis_codes = as.list(nomis_codes)
  names(nomis_codes) = nomis_codes
  
  if(length(parish_code) != 1 || !is.character(parish_code)) rlang::abort("Argument 'parish_code' must be a character vector of length one")
  if(!parish_code %in% p_table$parish_code) rlang::abort(c("Parish code:", x = parish_code, "is not valid"))
  
  diocese_no <- p_table$diocese_number[p_table$parish_code == parish_code]
  
  par_table <- read_parish_table()
  par_table <- par_table[par_table$parish_code %in% parish_code,]
  
  parish_stats  <- lapply(nomis_codes,
                          \(x){
                            stat_table <- coe_census_stats(nomis_code = x, level = "parish",  areas = parish_code, relative = relative) 
                            
                            stat_table$parish_name <- par_table$parish_name[match(stat_table$parish_code, par_table$parish_code)]
                            
                            stat_table <- coe_relocate(stat_table, c("parish_code", "parish_name"))
                            names(stat_table)[1:2] <- c("level_code", "level_name")
                            stat_table$level <- "parish"
                            stat_table <- coe_relocate(stat_table, "level")
                            stat_table
                            
                            })
  
  diocese_stats <- lapply(nomis_codes,
                          \(x){
                            stat_table <- coe_census_stats(nomis_code = x, level = "diocese", areas = diocese_no, relative = relative)
                            
                            stat_table$diocese_name <- par_table$diocese_name[match(stat_table$diocese_number, par_table$diocese_number)]
                            
                            stat_table <- coe_relocate(stat_table, c("diocese_number", "diocese_name"))
                            names(stat_table)[1:2] <- c("level_code", "level_name")
                            stat_table$level <- "diocese"
                            stat_table <- coe_relocate(stat_table, "level")
                            stat_table
                            
                            })
  england_stats <- lapply(nomis_codes,
                          \(x){
                            stat_table <- coe_census_stats(nomis_code = x, level = "england", relative = relative)
                            
                            stat_table$level <- "nation"
                            stat_table$level_code = NA_character_
                            stat_table$level_name = "england"
                            
                            stat_table <- coe_relocate(stat_table, c("level", "level_code", "level_name"))
                            stat_table
                            
                            })
  
  
  out <- vector("list", length(nomis_codes))
  names(out) <-  names(nomis_codes)
  
  for(code in names(nomis_codes)){
    out[[code]] <- rbind(parish_stats[[code]], diocese_stats[[code]], england_stats[[code]])
  }
  
  out
}


#' @noRd
coe_relocate <- function(.data, cols){
  out <- .data[,c(cols, setdiff(names(.data), cols))]
  out
}
