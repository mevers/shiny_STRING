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

ui <- fluidPage(

    useShinyjs(),
    extendShinyjs(script = "www/my_functions.js"),
    includeScript("http://string-db.org/javascript/combined_embedded_network_v2.0.2.js"),
    includeScript("https://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.js"),
    includeScript("https://cdnjs.cloudflare.com/ajax/libs/canvg/1.4/rgbcolor.min.js"),
    includeScript("https://cdnjs.cloudflare.com/ajax/libs/stackblur-canvas/1.4.1/stackblur.min.js"),
    includeScript("https://cdn.jsdelivr.net/npm/canvg/dist/browser/canvg.min.js"),
    includeCSS("www/style.css"),

    h2("STRING database explorer"),
    selectInput("organism", "Organism", ncbi_taxon_id),
    textInput("gene", "Gene symbol", value = "TP53"),
    actionButton("button", "Show network!"),
    actionButton("button_save", "Save network as PNG"),
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
        js$saveSVGasPNG()
    })

}

shinyApp(ui, server)
