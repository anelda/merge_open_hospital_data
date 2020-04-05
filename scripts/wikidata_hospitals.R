library(WikidataR)

### SOURCE TUTORIAL: https://www.mzes.uni-mannheim.de/socialsciencedatalab/article/studying-politics-wikipedia/#collecting-data-via-wikidata-queries

# get item based on item id
za_hosp_item <- get_item("Q6623687", language = "en")

# extract candidates
candidates <- extract_claims(za_hosp_item, claims = "P625")
candidates <- candidates[[1]][[1]]$mainsnak$datavalue$value

# collect the following attributes ("claims") for each candidate
claims <- c("P625", "P571", "P131", "P749", "P1329", "P856", "P6801", "P6855")
names(claims) <- c("coords", "open", "admin", "own", "phn", "web", "bed", "emerg")

za_hospitals_wikidata <-
  sapply(candidates,
         function (item) {
           tmp_item <- get_item(item, language = "en")
           sapply(claims,
                  function(claim) {
                    tmp_claim <- extract_claims(tmp_item, claim)[[1]][[1]]
                    if (any(is.na(tmp_claim))) {
                      return(NA)
                    } else {
                      tmp_claim <- tmp_claim$mainsnak$datavalue$value
                      if (is.atomic(tmp_claim)) {
                        return(tmp_claim)
                      } else if ("text" %in% names(tmp_claim)) {
                        return(tmp_claim$text)
                      } else if ("time" %in% names(tmp_claim)) {
                        tmp_claim <- as.Date(substr(tmp_claim$time, 2, 11))
                        return(tmp_claim)
                      } else if ("id" %in% names(tmp_claim)) {
                        tmp_claim <- tmp_claim$id
                        tmp_claim <- 
                          sapply(tmp_claim, 
                                 get_item, 
                                 language = "en",
                                 simplify = FALSE,
                                 USE.NAMES = TRUE)
                        tmp_claim <-
                          sapply(tmp_claim,
                                 function (x) {
                                   x[[1]]$labels$en$value
                                 })
                        return(tmp_claim)
                      }
                    }
                  },
                  simplify = FALSE,
                  USE.NAMES = TRUE)
         },
         simplify = FALSE,
         USE.NAMES = TRUE
  )
