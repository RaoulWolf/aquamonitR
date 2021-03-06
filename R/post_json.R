#' @title POST JSON to the AM API'
#'
#' @param token \code{character}: Valid API access token. If \code{NULL}, will first attempt to read credentials from a '.auth' file in the installation folder. If this fails, will prompt for username and password.
#' @param path \code{character}: Path to endpoint. Will be appended to 'host'.
#' @param in_json \code{list}: JSON to POST.
#'
#' @return \code{list}: Server response.
#' @importFrom curl curl_fetch_memory handle_setheaders handle_setopt new_handle
#' @importFrom jsonlite fromJSON toJSON
post_json <- function(token, path, in_json) {

  host <- .get_host()

  url <- paste0(host, path)

  header <- list("Content-Type" = "application/json", "Cookie" = paste0("aqua_key=", token))

  handle <- curl::new_handle()

  in_json <- jsonlite::toJSON(in_json, auto_unbox = TRUE)

  curl::handle_setopt(handle, customrequest = "POST", postfields = in_json)

  curl::handle_setheaders(handle, .list = header)

  response <- curl::curl_fetch_memory(url = url, handle = handle)

  if (response$status_code != 200L) {

    .report_json_error(response)

  }

  response <- rawToChar(response$content)

  Encoding(response) <- "UTF-8"

  response <- jsonlite::fromJSON(response, flatten = TRUE)

  response

}
