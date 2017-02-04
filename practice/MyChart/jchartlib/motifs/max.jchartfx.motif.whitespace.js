(function(){

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "whitespace";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates["Separator.stroke"] = "0,#EEEEEE";

    gaugeTemplates.whitespaceDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                        '<Grid Margin="0">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<TextBlock Margin="8,0" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontWeight="Bold" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}" />' +
                          '<Canvas Grid.Row="1" x:Name="targetChart" Margin="4"/>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.whitespaceRadialDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
          '<Thickness x:Key="borderFactor">0.02</Thickness>' +
        '</DataTemplate.Resources>' +
        '<Canvas>' +
          '<Ellipse Stroke="{Binding Class=Separator.stroke}" StrokeThickness="2" />' +
        '</Canvas>' +
      '</DataTemplate>';

    gaugeTemplates.whitespaceRadialIndicator = "RadialIndicatorRounded";

    gaugeTemplates.whitespaceRadialCap = "RadialCapPlain";

    gaugeTemplates.whitespaceRadialGlare = '<DataTemplate/>';

    gaugeTemplates.whitespaceLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.whitespaceLinearGlare = '<DataTemplate/>';

    gaugeTemplates.whitespaceLinearFiller = "LinearFillerSimple";

    gaugeTemplates.whitespaceLinearBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="-6">' +
          '<Border Fill="{Binding Path=Back}" Stroke="{x:Null}" CornerRadius="2" />' +
          '<Border Fill="{x:Null}" StrokeThickness="2" Stroke="#131616" StartCorner="3" Segments="2" CornerRadius="2" />' +
          '<Border Fill="{x:Null}" StrokeThickness="3" Stroke="#282A2B" StartCorner="1" Segments="2" CornerRadius="2" />' +
          '</Canvas>' +
        '</DataTemplate>';

    var gaugePalette = new cfx.gauge.Palette();
    gaugePalette.setColors([
        "#EEEEEE",       // Dashboard Back
        "#FFFFFF",  // Dashboard Inside
        "#EEEEEE",  // Border Back
        "#FFFFFF",  // Border Inside
        "#5D7C9B",  // Indicator
        "#465D75",       // Indicator Border
        "#5D7C9B",  // Filler
        "#465D75",       // Filler Border
        "#989898",  // Cap
        null,       // Cap Border
        "#989898",  // Scale
        "#EEEEEE",  // Bar Back
        "#DDDDDD",       // Bar Border
        null,       // Bar Alternate 
        "#BF7381",  // Section Back 0
        "#905761",       // Section Border 0
        null,       // Section Alternate 0
        "#F0B35F",  // Section Back 1
        "#B48748",       // Section Border 1
        null,       // Section Alternate 1
        "#73BFA1",  // Section Back 2
        "#579079",       // Section Border 2
        null,       // Section Alternate 2
        "#808080",  // Tickmark
        "#808080",  // Tickmark Inside
        "#555555",  // Title
        "#555555",  // Title Docked
        "#808080",  // Caption
        "#989898",  // Trend
        "#BF7381",  // Conditional Less
        "#F0B35F",  // Conditional Equal
        "#73BFA1",   // Conditional Greater
        "#666666",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#666666"    // ToolTipBorder
    ]);

    cfx.gauge.Palette.setDefaultPalette(gaugePalette);
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardTitle.fill"] = "0,#555555";
    chartTemplates["DashboardTitle.font-family"] = "1,'Open Sans', sans-serif";
    chartTemplates["DashboardTitle.font-size"] = "2,11";
    chartTemplates["AxisY_Text.fill"] = "0,#989898";
    chartTemplates["Separator.stroke"] = "0,#EEEEEE";

    chartTemplates.whitespaceBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                        '<Grid Margin="0">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<TextBlock Margin="8,0" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontWeight="Bold" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}" />' +
                          '<Canvas Grid.Row="1" x:Name="targetChart" Margin="4,0"/>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.whitespaceBar = "BarBasic";

    chartTemplates.whitespaceGantt = "GanttBasic";

    chartTemplates.whitespaceEqualizer = chartTemplates.whitespaceBar;

    chartTemplates.whitespaceLine = "LineBasic";

    chartTemplates.whitespaceCurve = "CurveBasic";

    chartTemplates.whitespaceArea = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:Double x:Key="cfxDefStrokeThickness">3</sys:Double>' +
                      '</DataTemplate.Resources>' +
                      '<Polygon Points="{Binding Path=PointsPolygon}" Fill="{Binding Path=Fill}" />' +
              '</DataTemplate>';

    chartTemplates.whitespaceCurveArea = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:Double x:Key="cfxDefStrokeThickness">3</sys:Double>' +
                      '</DataTemplate.Resources>' +
                      '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
              '</DataTemplate>';

    chartTemplates.whitespacePie = "PieBasic";

    chartTemplates.whitespaceBubble = "BubbleBasic";

    chartTemplates.whitespaceDoughnut = "DoughnutBasic";

    chartTemplates.whitespaceFunnel = "FunnelBasic";

    chartTemplates.whitespacePyramid = "PyramidBasic";

    chartTemplates.whitespaceSparklineLine = chartTemplates.whitespaceLine;

    chartTemplates.whitespaceSparklineBar = chartTemplates.whitespaceBar;

    chartTemplates.whitespaceSparklineArea = chartTemplates.whitespaceArea;

    var chartPalette = new cfx.Palette();
    chartPalette.setColors([
        "#5D7C9B",   // Series 0
        "#F0B35F",   // Series 1
        "#5F5474",   // Series 2
        "#4CB7C3",   // Series 3
        "#E5BDE4",   // Series 4
        "#BF7381",   // Series 5
        "#73BFA1",   // Series 6
        "#FFBC35",   // Series 7
        "#554C8E",   // Series 8
        "#34BCD9",   // Series 9
        "#5192C1",   // Series 10
        "#52C999",   // Series 11
        "#EDA1EB",   // Series 12
        "#D15770",   // Series 13
        "#F9F9F9",   // Series 14
        "#F5D34A",   // Series 15
        "#00000000", // Background
        "#00000000", // AlternateBackground
        "#00000000", // InsideBackground
        "#EEEEEE",   // Border
        "#EEEEEE",   // AxesAndGridlines
        "#F1F6F9",   // AxesAlternate
        "#666666",   // CustomGridLines
        "#F6F6F6",   // AxisSections
        "#989898",   // AxisLabels
        "#989898",   // PointLabels
        "#00000000", // MarkerBorder
        "#555555",   // TitlesFore
        "#00000000", // TitlesBack
        "#666666",   // LegendText
        "#00000000", // LegendBackground
        "#ffffff",   // DataBack
        "#666666",   // DataFore
        "#F1F6F9",   // DataBackAlternate
        "#666666",   // DataForeAlternate
        "#F6F6F6",   // DataTitlesBack
        "#666666",   // DataTitlesFore
        "#dbdbd9",   // DataGridlines
        "#ffffff",   // DataBackground
        "#666666",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#666666"    // ToolTipBorder
    ]);
    cfx.Chart.setDefaultPalette(chartPalette);
}


var whitespace = function whitespace()
{
}

cfx.motifs.whitespace = whitespace;

whitespace.getStyleInfo = function whitespace$global(args)
{
    var style = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            style = t[0];
        }
    }

    var styleInfo = {};
    styleInfo.isGroup = false;
    styleInfo.name = style;
    styleInfo.isSingle = false;
    styleInfo.isBullet = false;
    styleInfo.sections = new Array();

    if (style != undefined) {
        style = style.toUpperCase();
        if (style.indexOf("SINGLE") >= 0) {
            styleInfo.isSingle = true;
            styleInfo.name = "";
        }

        if (style.indexOf("GROUP") >= 0) {
            styleInfo.isGroup = true;
            styleInfo.name = "";
            styleInfo.name = "";
        }

        if (style.indexOf("BULLET") >= 0) {
            styleInfo.isBullet = true;
            styleInfo.name = "";
        }

        if (style.indexOf("SECTIONS") >= 0) {
            var index, index2;
            var sections;

            index = style.indexOf("SECTIONS");
            index2 = style.indexOf(":", index);
            if (index2 > 0) {
                index = index2;
                index2 = style.indexOf("-", index);
                if (index2 >= 0)
                    sections = style.substring(index + 1, index2);
                else
                    sections = style.substring(index + 1, style.length);
                styleInfo.sections = sections.split(",", 100);
            }
            styleInfo.name = "";
        }
    }

    return styleInfo;

}

whitespace.getChartGallery = function whitespace$global(args) {
    var gallery = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            gallery = t[0];
        }
    }

    return gallery;
}

whitespace.global = function whitespace$global(gauge)
{
    gauge.setFont("8pt Arial");
 
    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();

    scale.setAllowHalves(false);

    var defaultAttributes = gauge.getDefaultAttributes();
    defaultAttributes.setSectionThickness(0.1);
    defaultAttributes.setSectionPosition(0);
}

whitespace.radial = function whitespace$radial(gauge, args)
{
    whitespace.global(gauge);
 
    var styleInfo = whitespace.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);

    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();

    ticks.getMajor().setStyle(cfx.gauge.TickmarkStyle.Rectangle);
    ticks.getMajor().setWidth(0.05);
}

whitespace.linear = function whitespace$linear(gauge, args)
{
    whitespace.global(gauge);
    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();
    var bar = scale.getBar();
    var indicator = scale.getMainIndicator();

    ticks.getMajor().setStyle(cfx.gauge.TickmarkStyle.None);
    ticks.getMedium().setVisible(false);
    indicator.setSize(0.25);
    indicator.setPosition(0.375);
    bar.setThickness(0.05);
    bar.setPosition(0.475);

    var styleInfo = whitespace.getStyleInfo(args);
 
    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.9);
        scale.setPosition(0);
        indicator.setTitle("Current");
        var target = new cfx.gauge.Marker();
        target.setSize(0.4);
        target.setPosition(0.5);
        target.setTitle("Target");
        target.setTemplate("MarkerThinRectangle");
        scale.getIndicators().add(target);
        gauge.getDefaultAttributes().setSectionThickness(0.5);
        gauge.getDefaultAttributes().setSectionPosition(0.25);
    }

    if (styleInfo.sections.length > 0) {
        var section;
        var from = 0;
        var to;
        for (var i = 0; i < styleInfo.sections.length; i++) {
            to = styleInfo.sections[i];
            section = new cfx.gauge.ScaleSection();
            section.setFrom(from);
            section.setTo(to);
            gauge.getMainScale().getSections().add(section);
            from = to;
        }
        gauge.getMainScale().setMax(to);
    }


}

whitespace.vert = function whitespace$vert(gauge, args)
{
    whitespace.linear(gauge, args);
}

whitespace.horz = function whitespace$horz(gauge, args)
{
    whitespace.linear(gauge, args);
 
    var styleInfo = whitespace.getStyleInfo(args);

    if (!styleInfo.isBullet) {
        gauge.getBorder().setInsideGap(0);
        gauge.getMainScale().setThickness(0.3);
        gauge.getMainScale().setAlignment(cfx.StringAlignment.Near);
    }
}

whitespace.chart = function whitespace$chart(chart, args)
{
    var gallery = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            gallery = t[0];
        }
    }

    if (gallery != undefined) {
        gallery = gallery.toUpperCase();

        if (gallery == "GROUP") {
            chart.getBorder().setTemplate('<DataTemplate/>');
        }
    }

    var yGrids = chart.getAxisY().getGrids();
    yGrids.getMajor().setTickMark(cfx.TickMark.None);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);

    chart.getAllSeries().getBorder().setUseForLines(false);
    chart.getAllSeries().getLine().setWidth(1);
}

whitespace.map = function whitespace$map(map, args) {
    map.setShowAdditionalLayers(false);
}

whitespace.heatmap = function whitespace$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#5D7C9B");
    gradients.getItem(1).setColor("#F0B35F");
}

whitespace.equalizer = function whitespace$equalizer(equalizer, args) {
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F0B35F");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#5F5474");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#33CCCCCC");
}

whitespace.trend = function whitespace$trend(trend, args)
{
    var trendType = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            trendType = t[0];
        }
    }

    if (trendType != undefined) {
        if (trendType.toUpperCase().indexOf("SINGLE") >= 0) {
            trend.getDelta().setVisible(false);
            trend.getPercentChange().setVisible(false);
            trend.getIndicator().setVisible(false);
        }

        if (trendType.toUpperCase().indexOf("GROUP") >= 0) {
            trend.getBorder().setTemplate("<DataTemplate/>");
        }
    }

    trend.getSecondaryValues().setAlphaForeground(1);
}

})();