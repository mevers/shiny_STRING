library(shiny)
library(shinyjs)
library(V8)
library(httr)

email <- "maurits.evers@gmail.com"
version <- "1.1"
date <- "1 July 2020"
gh <- "https://github.com/mevers/shiny_STRING"

ncbi_taxon_id <- list(
    "Homo sapiens" = 9606,
    "Mus musculus" = 10090,
    "Drosophila melanogaster" = 7227,
    "Arabidopsis thaliana" = 3702)

# Note:
# 1. The 'identifiers' argument needs to be an array otherwise we get an error:
#    TypeError: value.join is not a function.
# 2. Best to let shinyjs match function arguments via shinyjs.getParams; see:
#    https://cran.r-project.org/web/packages/shinyjs/vignettes/shinyjs-extend.html
#    This also means we can avoid a req(input$gene) in onclick("button")
jsCode <- "
    shinyjs.loadStringData = function(params) {
        var defaultParams = {
            organism : '9606',
            gene : 'TP53'
        };
        params = shinyjs.getParams(params, defaultParams);
        getSTRING('https://string-db.org', {
            'species': params.organism,
            'identifiers': [params.gene],
            'network_flavor':'confidence'});
    }"


ui <- fluidPage(

    useShinyjs(),
    extendShinyjs(text = jsCode),
    includeScript("http://string-db.org/javascript/combined_embedded_network_v2.0.2.js"),
    includeCSS("www/style.css"),

    h2("STRING database explorer"),
    selectInput("organism", "Organism", ncbi_taxon_id),
    textInput("gene", "Gene symbol", value = "TP53"),
    actionButton("button", "Show network!"),
    actionButton("button_save", "Save static network as PNG"),
    tags$div(id = "stringEmbedded"),
    HTML(sprintf("<footer id = 'footer'>
        Author: <a href='mailto:%s?subject=STRING db explorer'>%s</a>,
        version %s,
        %s,
        <a href='%s'>%s</a>
        </footer>", email, email, version, date, gh, gh))
)

server <- function(input, output, session) {

    onclick("button", {
        js$loadStringData(input$organism, input$gene)
    })

    onclick("button_save", {
        baseurl <- "https://string-db.org/api/image/network?identifiers="
        url <- sprintf("%s%s", baseurl, paste0(input$gene, collapse = "%0d"))
        GET(url, write_disk("network.png", overwrite = TRUE))
    })

}

shinyApp(ui, server)
