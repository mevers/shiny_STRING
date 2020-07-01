shinyjs.loadStringData = function(params) {

    // Note:
    // 1. The 'identifiers' argument needs to be an array otherwise we get an
    //    error: TypeError: value.join is not a function.
    // 2. Best to let shinyjs match function arguments via shinyjs.getParams;
    //    see:
    //    https://cran.r-project.org/web/packages/shinyjs/vignettes/shinyjs-extend.html
    //    This also means we can avoid a req(input$gene) in onclick("button")

    var defaultParams = {
        organism : '9606',
        gene : 'TP53'
    };

    params = shinyjs.getParams(params, defaultParams);

    getSTRING('https://string-db.org', {
        'species': params.organism,
        'identifiers': [params.gene],
        'network_flavor':'confidence'});
};

shinyjs.saveSVGasPNG = function() {

    // Initiate download of blob
    function download(filename, blob) {
        if (window.navigator.msSaveOrOpenBlob) {
            window.navigator.msSaveBlob(blob, filename);
        } else {
            const elem = window.document.createElement('a');
            elem.href = window.URL.createObjectURL(blob);
            elem.download = filename;
            document.body.appendChild(elem);
            elem.click();
            document.body.removeChild(elem);
        }
    };

    var svg = document.querySelector('#svg_network_image');
    console.log(svg)
    var data = (new XMLSerializer()).serializeToString(svg);

    var canvas = document.createElement('canvas');
    canvg(canvas, data, {
        renderCallback: function () {
            canvas.toBlob(function (blob) {
                   download('my_network.png', blob);
            });
        }
    });
};
