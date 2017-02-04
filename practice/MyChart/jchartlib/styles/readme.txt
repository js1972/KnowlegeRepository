
     jChartFX Styles and Motifs
================================

jChartFX includes a series of css files that allow you to easily customize any of the controls through style sheets. More than 60 different looks and color styles are available. There is a pair of files for each of the different looks and styles:

- Palette: the jchartfx.palette.<stylename>.js file contains all the color features available.

- Attributes: the jchartfx.attributes.<stylename>.js file contains the rest of the features used in configuration of jChartFX that are not color related, such as fonts, stroke-width, etc.

The reason for this separation is to allow combining any of the styles and motifs with any of the color palettes, which provides more than 600 possible combinations.

In addition to the attributes and palette css files, jChartFX includes a series of .js Motif files, available in the motif subfolder. A motif allows to provide a complete different look to a jChartFX dashboard without the need to code the aesthetics for any of the controls. To use a motif simply include it in your page, after you have included jchartfx.system.js. When you include a motif, you should also include its corresponding attributes and palette css files. For example, if you include jchartfx.motif.hook.js, you should also include jchartfx.attributes.hook.css and jchartfx.palette.hook.css. However, you can use any of the other palette files for a didfferent color combintation, although you you should still use the attribute css file that matches the motif you are using.

The Motifs that are currently included with jChartFX are:

- jchart.motif.js
- jchartfx.motif.aurora.js
- jchartfx.motif.glow.js
- jchartfx.motif.handdrawn.js
- jchartfx.motif.healthy.js
- jchartfx.motif.hook.js
- jchartfx.motif.lizard.js
- jchartfx.motif.metro.js
- jchartfx.motif.topbar.js
- jchartfx.motif.whitespace.js

You can see an interactive demo of these motifs at www.jchartfx.com/motifs.
