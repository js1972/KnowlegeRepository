(function(){

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "handdrawn";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.handdrawnDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                        '<Thickness x:Key="borderGap">2</Thickness>' +
                        '<Thickness x:Key="externalGap">2</Thickness>' +
                      '</DataTemplate.Resources>' +
                      '<Border BorderBrush="{Binding Path=Stroke}" BorderThickness="1"/>' +
                      '<Canvas>' +
                        '<Grid Margin="0">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<TextBlock Margin="8,0" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontWeight="Bold" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" />' +
                          '<Canvas Grid.Row="1" x:Name="targetChart" Margin="4"/>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.handdrawnRadialDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
          '<Thickness x:Key="borderFactor">0.03</Thickness>' +
        '</DataTemplate.Resources>' +
          '<Ellipse Stroke="{Binding Path=Stroke}"/>' +
      '</DataTemplate>';

    gaugeTemplates.handdrawnRadialIndicator = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Rectangle Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
      '</DataTemplate>';

    gaugeTemplates.handdrawnRadialCap = "RadialCapDefault";

    gaugeTemplates.handdrawnRadialGlare = '<DataTemplate/>';

    gaugeTemplates.handdrawnLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.handdrawnLinearGlare = '<DataTemplate/>';

    gaugeTemplates.handdrawnLinearFiller = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Rectangle Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
      '</DataTemplate>';

    var gaugePalette = new cfx.gauge.Palette();
    gaugePalette.setColors([
        "#DBDBD9",        // Dashboard Back
        "#FFFFFF",   // Dashboard Inside
        "#DBDBD9", // Border Back
        "#FFFFFF",   // Border Inside
        "#EE7323",   // Indicator
        "#B3571B",        // Indicator Border
        "#EE7323",   // Filler
        "#B3571B",        // Filler Border
        "#666666",   // Cap
        null,        // Cap Border
        "#666666", // Scale
        "#FFFFFF", // Bar Back
        "#767778",        // Bar Border
        null,        // Bar Alternate
        "#FF0B00",   // Section Back 0
        "#C00900",        // Section Border 0
        null,        // Section Alternate 0
        "#EBF928",   // Section Back 1
        "#B1BB1E",        // Section Border 1
        null,        // Section Alternate 1
        "#49EA22",   // Section Back 2
        "#37B01A",        // Section Border 2
        null,        // Section Alternate 2
        "#DBDBD9", // Tickmark
        "#DBDBD9", // Tickmark Inside
        "#929394",   // Title
        "#929394",   // Title Docked
        "#A0A0A0",   // Caption
        "#666666", // Trend
        "#FF0B00",   // Conditional Less
        "#EBF928",        // Conditional Equal
        "#49EA22",   // Conditional Greater
        "#666666",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#666666"    // ToolTipBorder
    ]);

    cfx.gauge.Palette.setDefaultPalette(gaugePalette);
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardTitle.fill"] = "0,#929394";
    chartTemplates["DashboardTitle.font-family"] = "1,Handwritten";
    chartTemplates["DashboardTitle.font-size"] = "2,18";
    chartTemplates["AxisY_Text.fill"] = "0,#666666";

    chartTemplates.handdrawnBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                        '<sys:String x:Key="borderGap">2</sys:String>' +
                        '<sys:String x:Key="externalGap">2</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Border BorderBrush="{Binding Path=Stroke}" BorderThickness="1"/>' +
                      '<Canvas>' +
                        '<Grid Margin="0">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<TextBlock Margin="8,0" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontWeight="Bold" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" />' +
                          '<Canvas Grid.Row="1" x:Name="targetChart" Margin="4,0"/>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.handdrawnBar = "BarBasic";

    chartTemplates.handdrawnLine = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Polyline Points="{Binding Path=Points}" Stroke="{Binding Path=Stroke}" StrokeThickness="{Binding Path=StrokeThickness}" />' +
        '</DataTemplate>';

    chartTemplates.handdrawnCurve = "CurveBasic";

    chartTemplates.handdrawnCurveArea = "CurveAreaBasic";

    chartTemplates.handdrawnArea = "AreaBasic";

    chartTemplates.handdrawnPie = "PieBasic";

    chartTemplates.handdrawnDoughnut = "DoughnutBasic";

    chartTemplates.handdrawnBubble = "BubbleBasic";

    chartTemplates.handdrawnBullet = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                    '<DataTemplate.Resources>' +
                      '<DataTemplate x:Key="templateLine">' +
                        '<Line X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}" Stroke="{Binding Path=Stroke}" StrokeThickness="3" />' +
                      '</DataTemplate>' +
                    '</DataTemplate.Resources>' +
                    '<Canvas>' +
                    '<Rectangle Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
                    '</Canvas>' +
                    '</DataTemplate>';

    chartTemplates.klipEqualizer = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<DataTemplate x:Key="off">' +
                '<Rectangle Fill="{Binding Path=Fill}" />' +
            '</DataTemplate>' +
        '</DataTemplate.Resources>' +
        '<Canvas Margin="0">' +
            '<Rectangle Fill="{Binding Path=Fill}" />' +
        '</Canvas>' +
    '</DataTemplate>';

    var chartPalette = new cfx.Palette();
    chartPalette.setColors([
        "#EE7323",   // Series 0
        "#3083FD",   // Series 1
        "#F51EF5",   // Series 2
        "#49EA22",   // Series 3
        "#EBF928",   // Series 4
        "#FF0B00",   // Series 5
        "#31BEF3",   // Series 6
        "#B75BE0",   // Series 7
        "#FC8D07",   // Series 8
        "#F7A7FE",   // Series 9
        "#FDFE86",   // Series 10
        "#D20000",   // Series 11
        "#FE9900",   // Series 12
        "#8B698A",   // Series 13
        "#CCCD67",   // Series 14
        "#66C226",   // Series 15
        "#00000000",   // Background
        "#00000000",   // AlternateBackground
        "#00000000", // InsideBackground
        "#dbdbd9",   // Border
        "#dbdbd9",   // AxesAndGridlines
        "#f5f5ee",   // AxesAlternate
        "#3083FD",   // CustomGridLines
        "#404447",   // AxisSections
        "#666666",   // AxisLabels
        "#666666",   // PointLabels
        "#00000000", // MarkerBorder
        "#929394",   // TitlesFore
        "#00000000", // TitlesBack
        "#666666",   // LegendText
        "#00000000", // LegendBackground
        "#FFFFFF",   // DataBack
        "#666666",   // DataFore
        "#AAAAAA",   // DataBackAlternate
        "#dbdbd9",   // DataForeAlternate
        "#EE7323",   // DataTitlesBack
        "#252729",   // DataTitlesFore
        "#dbdbd9",   // DataGridlines
        "#252729",   // DataBackground
        "#666666",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#666666"    // ToolTipBorder
    ]);
    cfx.Chart.setDefaultPalette(chartPalette);
}


var handdrawn = function handdrawn()
{
}

cfx.motifs.handdrawn = handdrawn;

handdrawn.extension = null;

handdrawn.getStyleInfo = function handdrawn$global(args)
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

handdrawn.init = function handdrawn$global()
{
    handdrawn.extension = new cfx.handdrawn.HandDrawn();
}

handdrawn.addGaugeExtension = function handdrawn$addGaugeExtension(gauge)
{
    if (handdrawn.extension == null)
        handdrawn.init();
 
    gauge.addExtension(handdrawn.extension);
}

handdrawn.global = function handdrawn$global(gauge)
{
    handdrawn.addGaugeExtension(gauge);
    gauge.setFont("24pt Handwritten");
 
    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();

    scale.setAllowHalves(false);
}

handdrawn.radial = function handdrawn$radial(gauge, args)
{
    handdrawn.global(gauge);
 
    gauge.getDashboardBorder().setInsideGap(0.1);
 
    var styleInfo = handdrawn.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);
}

handdrawn.linear = function handdrawn$linear(gauge, args)
{
    handdrawn.global(gauge);
    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();
    var bar = scale.getBar();
    var mainIndicator = gauge.getMainIndicator();

    ticks.getMedium().setVisible(false);
    ticks.getMajor().setSize(0.2);
    ticks.getMajor().setPosition(0.55);

    var styleInfo = handdrawn.getStyleInfo(args);

    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.9);
        scale.setPosition(0);
        mainIndicator.setSize(0.25);
        mainIndicator.setPosition(0.475);
        mainIndicator.setTitle("Current");
        var target = new cfx.gauge.Marker();
        target.setSize(0.4);
        target.setPosition(0.6);
        target.setTitle("Target");
        target.setTemplate("MarkerThinRectangle");
        scale.getIndicators().add(target);
        gauge.getDefaultAttributes().setSectionThickness(bar.getThickness());
        gauge.getDefaultAttributes().setSectionPosition(bar.getPosition());
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

handdrawn.vert = function handdrawn$vert(gauge, args)
{
    handdrawn.linear(gauge, args);
}

handdrawn.horz = function handdrawn$horz(gauge, args)
{
    handdrawn.linear(gauge, args);
}

handdrawn.chart = function handdrawn$chart(chart, args)
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

    if (handdrawn.extension == null)
        handdrawn.init();

    chart.getExtensions().add(handdrawn.extension);

    var yGrids = chart.getAxisY().getGrids();
    yGrids.getMajor().setTickMark(cfx.TickMark.None);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);
 
    var xGrids = chart.getAxisX().getGrids();
    xGrids.getMinor().setTickMark(cfx.TickMark.None);
    xGrids.getMajor().setTickMark(cfx.TickMark.None);
 
    chart.setFont("14pt HandWritten");
}

handdrawn.heatmap = function handdrawn$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#EE7323");
    gradients.getItem(1).setColor("#3083FD");
}

handdrawn.equalizer = function handdrawn$equalizer(equalizer, args) {
    equalizer.setRoundnessRatio(0);
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#3083FD");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F51EF5");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#10EE7323");
}

handdrawn.trend = function handdrawn$trend(trend, args)
{
    handdrawn.addGaugeExtension(trend);
 
    trend.getSecondaryValues().setAlphaForeground(1);
    trend.setFontName("HandWritten");

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
}

handdrawn.border = function handdrawn$border(border, args)
{
    handdrawn.addGaugeExtension(border);
}

})();