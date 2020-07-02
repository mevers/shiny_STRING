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
        'network_flavor':'confidence'
    });
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

    function scaleSVG(svg, width, height) {
        // Need to clone svg otherwise changes will affect the original SVG
        // Note to self: All function arguments in JS are mutable bindings
        var svg_scaled = svg.cloneNode(true);
        var orgWidth = parseFloat(svg.getAttribute("width"));
        var orgHeight = parseFloat(svg.getAttribute("height"));
        svg_scaled.setAttribute("width", width);
        svg_scaled.setAttribute("height", height);
        svg_scaled.setAttribute("viewBox", "0 0 " + orgWidth + " " + orgHeight);
        return svg_scaled;
    };

    // Get SVG and rescale
    var svg = document.querySelector('#svg_network_image');
    var scaled_svg = scaleSVG(svg, width = 1280, height = 800);

    var data = (new XMLSerializer()).serializeToString(scaled_svg);

    var canvas = document.createElement('canvas');
    canvg(canvas, data, {
        renderCallback: function () {
            canvas.toBlob(function (blob) {
                   download('my_network.png', blob);
            });
        }
    });
};
