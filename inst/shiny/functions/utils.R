# Create zero-prefixed list of pcs so that each element
# in the list has the same length.
create_formated_pcs_list <- function(pcs_count){
  pcs_list <- 1:pcs_count

  for(i in pcs_list){
    zeros_count <- nchar(pcs_count) - nchar(i)
    prefix <- paste(rep('0', zeros_count), collapse = "")
    pcs_list[i] <- paste0(prefix, pcs_list[i])
  }

  pcs_list
}
