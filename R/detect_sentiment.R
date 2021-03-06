#' @title Detect sentiment in a source text
#' @description Detect sentiment in a source text
#' @param text A character string containing a text to sentiment analyze, or a character vector to perform analysis separately for each element.
#' @param language A character string containing a two-letter language code. Currently \dQuote{en} and \dQuote{es} are supported.
#' @param \dots Additional arguments passed to \code{\link{comprehendHTTP}}.
#' @return A data frame
#' @examples
#' \dontrun{
#'   # simple example
#'   detect_sentiment("I have never been happier. This is the best day ever.")
#'
#'   txt <-c("I have never been happier. This is the best day ever.",
#'           "I have always been happier. This is the worst day ever.")
#'   detect_sentiment(txt)
#' }
#' @export
detect_sentiment <-
function(
  text,
  language = "en",
  ...
) {
    if (length(text) > 1L) {
        bod <- list(TextList = text, LanguageCode = language)
        out <- comprehendHTTP(action = "BatchDetectSentiment", body = bod, ...)
        # build response data frame
        formatted <- cbind(out$ResultList[c("Index", "Sentiment")],
                           out$ResultList[["SentimentScore"]])
        return(structure(formatted, ErrorList = out$ErrorList))
    } else {
        bod <- list(Text = text, LanguageCode = language)
        out <- comprehendHTTP(action = "DetectSentiment", body = bod, ...)
        formatted <- cbind(Index = 0,
                           Sentiment = out$Sentiment,
                           flatten(out$SentimentScore),
                           stringsAsFactors = FALSE)
        return(formatted)
    }
}
