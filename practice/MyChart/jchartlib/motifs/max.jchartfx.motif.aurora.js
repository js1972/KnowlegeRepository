(function () {

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "aurora";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.auroraDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                          '<Border Background="{Binding Path=Fill}">' +
                            '<Grid Margin="1">' +
                              '<Grid.RowDefinitions>' +
                                '<RowDefinition Height="Auto" MinHeight="10"/>' +
                                '<RowDefinition Height="*"/>' +
                                '<RowDefinition Height="Auto" MinHeight="32"/>' +
                                '<RowDefinition Height="Auto" MinHeight="4"/>' +
                              '</Grid.RowDefinitions>' +
                               '<Border Grid.Row="0" Height="1" Background="#33000000" />' +
                              '<Border Grid.Row="1" Background="{Binding Path=Fill}">' +
                                '<Canvas x:Name="targetChart" Margin="4"/>' +
                              '</Border>' +
                              '<Border Grid.Row="2" Background="{Binding Path=Fill}">' +
                                '<TextBlock Margin="21,8,21,8" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" />' +
                              '</Border>' +
                            '<Border Grid.Row="3" Height="4" Background="#33000000">' +
                            '</Border>' +
                            '</Grid>' +
                        '</Border>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.auroraRadialDashBorder = "<DataTemplate/>";

    gaugeTemplates.auroraRadialIndicator = "NeedleRegularDrop";

    gaugeTemplates.auroraRadialCap = '<DataTemplate>' +
                '<Ellipse Fill="{Binding Path=Fill}"/>' +
                '<Ellipse Stroke="#11333333" StrokeThickness="3" />' +
            '</DataTemplate>';

    gaugeTemplates.auroraRadialGlare = '<DataTemplate/>';

    gaugeTemplates.auroraLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.auroraLinearGlare = '<DataTemplate/>';

    gaugeTemplates.auroraLinearFiller = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerRadius="5"/>' +
          '<Border Stroke="#11333333" StrokeThickness="3" CornerRadius="5"/>' +
          '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.auroraRadialFiller = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
            '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
            '<Path Data="{Binding Path=Geometry}" Stroke="#11333333" StrokeThickness="3" />' +
            '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.auroraRadialBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
    '<Canvas Margin="0">' +
        '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
        '<Path Data="{Binding Path=Geometry}" Stroke="#11333333" StrokeThickness="3" />' +
        '<Path Data="{Binding Path=Geometry}">' +
        '<Path.Fill>' +
                '<LinearGradientBrush StartPoint="0,0" EndPoint="0,1" >' +
                    '<GradientStop Color="#22000000" Offset="0"/>' +
                    '<GradientStop Color="#00000000" Offset="1"/>' +
                '</LinearGradientBrush>' +
        '</Path.Fill>' +
        '</Path>' +
        '</Canvas>' +
  '</DataTemplate>';

    gaugeTemplates.auroraLinearBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerRadius="5"/>' +
          '<Border Stroke="#11333333" StrokeThickness="3" CornerRadius="5"/>' +
          '<Border CornerRadius="5">' +
            '<Border.Fill>' +
                '<LinearGradientBrush StartPoint="0,0" EndPoint="0,1" >' +
                    '<GradientStop Color="#22000000" Offset="0"/>' +
                    '<GradientStop Color="#00000000" Offset="1"/>' +
                '</LinearGradientBrush>' +
            '</Border.Fill>' +
          '</Border>' + 
          '</Canvas>' +
        '</DataTemplate>';

    var gaugePalette = new cfx.gauge.Palette();
    gaugePalette.setColors([
        "#20CFB6",   // Dashboard Back
        "#373A41",   // Dashboard Inside
        "#20CFB6",   // Border Back
        "#373A41",   // Border Inside
        "#329287",   // Indicator
        "#266E66",   // Indicator Border
        "#329287",   // Filler
        "#266E66",        // Filler Border
        "#626364",   // Cap
        null,   // Cap Border
        "#AAAFB9",   // Scale
        "#2F3238",   // Bar Back 
        "#151619",   // Bar Border 
        null,   // Bar Alternate 
        "#E04E61",   // Section Back 0
        "#A83B49",   // Section Border 0
        null,   // Section Alternate 0
        "#E9EA52",   // Section Back 1
        "#AFB03E",   // Section Border 1
        null,   // Section Alternate 1
        "#65C773",   // Section Back 2
        "#4C9657",    // Section Border 2
        null,    // Section Alternate 2
        "#C0C0C0",   // Tickmark
        "#C0C0C0",   // Tickmark Inside
        "#868A8E",   // Title
        "#868A8E",   // Title Docked
        "#808080",   // Caption
        "#AAAFB9",   // Trend
        "#E04E61",   // Conditional Less
        "#E9EA52",        // Conditional Equal
        "#65C773",   // Conditional Greater
        "#868A8E",   // ToolTipText
        "#26292D",   // ToolTipBack
        "#202327"    // ToolTipBorder
    ]);

    cfx.gauge.Palette.setDefaultPalette(gaugePalette);
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardTitle.fill"] = "0,#868A8E";
    chartTemplates["DashboardTitle.font-family"] = "1,'Roboto', sans-serif";
    chartTemplates["DashboardTitle.font-size"] = "2,11";
    chartTemplates["AxisY_Text.fill"] = "0,#626364";

    chartTemplates.auroraBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                        '<Thickness x:Key="externalMargin">16</Thickness>' +
                        '<Thickness x:Key="internalRectMargin">0</Thickness>' +
                        '<DataTemplate x:Key="internalRect">' +
                          '<Border CornerRadius="6" Background="{Binding Path=Fill}" BorderBrush="{Binding Path=Stroke}" CornerPercent="0.5" />' +
                        '</DataTemplate>' +
                        '<DataTemplate x:Key="internal">' +
                          '<Line Stroke="{Binding Path=Stroke}" X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}"/>' +
                        '</DataTemplate>' +
                      '</DataTemplate.Resources>' +
                        '<Canvas>' +
                      '<Border Background="{Binding Path=Fill}">' +
                          '<Grid Margin="1">' +
                            '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="10"/>' +
                              '<RowDefinition Height="*"/>' +
                              '<RowDefinition Height="Auto" MinHeight="32"/>' +
                              '<RowDefinition Height="Auto" MinHeight="4"/>' +
                            '</Grid.RowDefinitions>' +
                            '<Border Grid.Row="0" Height="1" Background="#33000000" />' +
                            '<Border Grid.Row="1" Background="{Binding Path=Fill}">' +
                                '<Canvas x:Name="targetChart" Margin="20,0,20,0"/>' +
                            '</Border>' +
                            '<Border Grid.Row="2" Background="{Binding Path=Fill}">' +
                                '<TextBlock Margin="21,8,21,8" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" FontSize="{Binding Class=DashboardTitle.font-size}" FontFamily="{Binding Class=DashboardTitle.font-family}" />' +
                            '</Border>' +
                              '<Border Grid.Row="3" Height="4" Background="#33000000">' +
                            '</Border>' +
                          '</Grid>' +
                      '</Border>' +
                    '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.auroraBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerRadius="5"/>' +
          '<Border Stroke="#11333333" StrokeThickness="3" CornerRadius="5"/>' +
          '</Canvas>' +
        '</DataTemplate>';

    chartTemplates.auroraGantt = chartTemplates.auroraBar;

    chartTemplates.auroraArea = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                  '<DataTemplate.Resources>' +
                    '<sys:Double x:Key="cfxDefStrokeThickness">3</sys:Double>' +
                  '</DataTemplate.Resources>' +
                  '<Canvas>' +
                        '<Polygon Points="{Binding Path=PointsPolygon}" Fill="{Binding Path=Fill}" />' +
                        '<Polygon Points="{Binding Path=PointsPolygon}" Stroke="#11333333" StrokeThickness="3" />' +
                  '</Canvas>' +
          '</DataTemplate>';

    chartTemplates.auroraLine = "LineBasic";

    chartTemplates.auroraCurve = "CurveBasic";

    chartTemplates.auroraCurveArea = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
             '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
             '<Path Data="{Binding Path=Geometry}" Stroke="#11333333" StrokeThickness="3" />' +
        '</Canvas>' +
'</DataTemplate>';

    chartTemplates.auroraBubble = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
            '<Ellipse Fill="{Binding Path=Fill}" />' +
            '<Ellipse Stroke="#11333333" StrokeThickness="3"/>' +
        '</Canvas>' +
'</DataTemplate>';

    chartTemplates.auroraOverlayBubble = chartTemplates.auroraBubble;

    chartTemplates.auroraPyramid = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
            '<Polygon Points="{Binding Path=PointsPolygon}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" StrokeThickness="{Binding Path=StrokeThickness}" />' +
            '<Polygon Points="{Binding Path=PointsPolygon}" Stroke="#11333333" StrokeThickness="3" />' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.auroraFunnel = chartTemplates.auroraPyramid;

    chartTemplates.auroraPie = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
        '<Path Data="{Binding Path=Geometry}" Stroke="#11333333" StrokeThickness="3" />' +
    '</DataTemplate>';

    chartTemplates.auroraDoughnut = chartTemplates.auroraPie;

    chartTemplates.auroraTreeMap = chartTemplates.auroraBar;

    chartTemplates.auroraHeatMap = chartTemplates.auroraBar;

    chartTemplates.auroraDensity = '<DataTemplate xmlns:x="a">' +
        '<Canvas Margin="0">' +
                '<Border Fill="{Binding Path=Fill}" CornerRadius="5"/>' +
                '<Border Stroke="#11333333" StrokeThickness="1" CornerRadius="5"/>' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.auroraSparklineLine = chartTemplates.auroraLine;

    chartTemplates.auroraSparklineBar = chartTemplates.auroraBar;

    chartTemplates.auroraSparklineArea = chartTemplates.auroraArea;

    chartTemplates.auroraSparklineCurve = chartTemplates.auroraCurve;

    chartTemplates.auroraSparklineCurveArea = chartTemplates.auroraCurveArea;

    chartTemplates.auroraBullet = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                '<DataTemplate.Resources>' +
                  '<DataTemplate x:Key="templateLine">' +
                    '<Line X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}" Stroke="{Binding Path=Stroke}" StrokeThickness="3" />' +
                  '</DataTemplate>' +
                '</DataTemplate.Resources>' +
                '<Canvas>' +
                      '<Border Fill="{Binding Path=Fill}" CornerRadius="5"/>' +
                      '<Border Stroke="#11333333" StrokeThickness="1" CornerRadius="5"/>' +
                '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.auroraEqualizer = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                '<DataTemplate.Resources>' +
                    '<DataTemplate x:Key="off">' +
                        '<Canvas>' +
                            '<Border Opacity="{Binding Path=Opacity}" Background="{Binding Path=Fill}" CornerRadius="2" CornerPercent="1" />' +
                            '<Border Opacity="{Binding Path=Opacity}" BorderBrush="#11333333" BorderThickness="1" CornerRadius="2" CornerPercent="1" />' +
                        '</Canvas>' +
                    '</DataTemplate>' +
                '</DataTemplate.Resources>' +
                '<Canvas>' +
                    '<Border Opacity="{Binding Path=Opacity}" Background="{Binding Path=Fill}" CornerRadius="2" CornerPercent="1" />' +
                    '<Border Opacity="{Binding Path=Opacity}" BorderBrush="#11333333" BorderThickness="1" CornerRadius="2" CornerPercent="1" />' +
                '</Canvas>' +
        '</DataTemplate>';

    chartTemplates.auroraRose = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                  '<DataTemplate.Resources>' +
                    '<sys:Double x:Key="cfxDefStrokeThickness">3</sys:Double>' +
                  '</DataTemplate.Resources>' +
                  '<Canvas>' +
                      '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
                      '<Path Data="{Binding Path=Geometry}" Stroke="#11333333" StrokeThickness="3" />' +
                  '</Canvas>' +
          '</DataTemplate>';

    chartTemplates.auroraMarker1 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
    '<Border Background="{Binding Path=Fill}" BorderBrush="{Binding Path=Stroke}" BorderThickness="{Binding Path=StrokeThickness}" CornerRadius="5" />' +
'</DataTemplate>';

    var chartPalette = new cfx.Palette();
    chartPalette.setColors([
        "#329287",   // Series 0
        "#477EA5",   // Series 1
        "#75AE50",   // Series 2
        "#50525D",   // Series 3
        "#965994",   // Series 4
        "#65c773",   // Series 5
        "#5abec7",   // Series 6
        "#ce9884",   // Series 7
        "#5f6775",   // Series 8
        "#e9ea52",   // Series 9
        "#e04e61",   // Series 10
        "#6fe4c8",   // Series 11
        "#eca63f",   // Series 12
        "#99d0a0",   // Series 13
        "#ce8fbe",   // Series 14
        "#8dc3e0",   // Series 15
        "#373A41",   // Background
        "#373A41",   // AlternateBackground
        "#00000000", // InsideBackground
        "#20CFB6",   // Border
        "#313439",   // AxesAndGridlines
        "#3D4148",   // AxesAlternate
        "#848F93",   // CustomGridLines
        "#5B6472",   // AxisSections
        "#626364",   // AxisLabels
        "#626364",   // PointLabels
        "#00000000", // MarkerBorder
        "#868A8E",   // TitlesFore
        "#00000000", // TitlesBack
        "#626364",   // LegendText
        "#00000000", // LegendBackground
        "#373A41",   // DataBack
        "#626364",   // DataFore
        "#3D4148",   // DataBackAlternate
        "#727374",   // DataForeAlternate
        "#313439",   // DataTitlesBack
        "#868A8E",   // DataTitlesFore
        "#313439",   // DataGridlines
        "#373A41",   // DataBackground
        "#868A8E",   // ToolTipText
        "#26292D",   // ToolTipBack
        "#202327"    // ToolTipBorder
    ]);

    cfx.Chart.setDefaultPalette(chartPalette);
}

var aurora = function aurora()
{
}

cfx.motifs.aurora = aurora;

aurora.getStyleInfo = function aurora$global(args)
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

aurora.global = function aurora$global(gauge) {
    gauge.setFont("8pt 'Roboto', sans-serif");
}

aurora.radial = function aurora$radial(gauge, args)
{
    aurora.global(gauge);
 
    var styleInfo = aurora.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);

    var mainScale = gauge.getMainScale();
    var mainIndicator = gauge.getMainIndicator();

    if (styleInfo.name == "progress") {
        mainScale.setThickness(1);
        mainScale.setPosition(0);
        var bar = mainScale.getBar();
        bar.setVisible(true);
        bar.setTemplate(gaugeTemplates.auroraRadialBar);
        bar.setThickness(0.25);
 
        var tickmarks = mainScale.getTickmarks();
        var major = tickmarks.getMajor();
        major.setVisible(true);
        major.setWidth(0.01);
        major.setSize(0.04);
        major.setStyle(cfx.gauge.TickmarkStyle.Line);
        major.setPosition(0.03);
        mainScale.setAlignment(cfx.StringAlignment.Near);
        mainScale.setStartAngle(130);
        mainScale.setSweepAngle(280);
        
        var filler = new cfx.gauge.Filler();
        filler.setTemplate(gaugeTemplates.auroraRadialFiller);
        filler.setPosition(0.25);
        filler.setSize(0.25);
        gauge.setMainIndicator(filler);
    }
    else {
        mainScale.setThickness(0.6);
        mainScale.setPosition(0);
        mainScale.setAllowHalves(false);
        var bar = mainScale.getBar();
        bar.setVisible(true);
        bar.setTemplate(gaugeTemplates.auroraRadialBar);
        bar.setThickness(0.23);
        bar.setPosition(.34);

        var tickmarks = mainScale.getTickmarks();
        var major = tickmarks.getMajor();
        major.setVisible(true);
        major.setWidth(0.01);
        major.setSize(0.02);
        major.setStyle(cfx.gauge.TickmarkStyle.Line);
        major.setPosition(0);
        mainScale.setAlignment(cfx.StringAlignment.Near);

        var cap = mainScale.getCap();
        cap.setSize(0.3);

        mainScale.setStartAngle(140);
        mainScale.setSweepAngle(260);

        mainIndicator.setSize(0.9);
        mainIndicator.setPosition(0.75);

        tickmarks.getMedium().setVisible(false);
        var defaultAttributes = gauge.getDefaultAttributes();
        defaultAttributes.setSectionPosition(0.275);
        defaultAttributes.setSectionThickness(0.01);
    }
}

aurora.linear = function aurora$linear(gauge, args)
{
    aurora.global(gauge);
    var scale = gauge.getMainScale();
    var bar = scale.getBar();

    bar.setVisible(true);
    bar.setPosition(0.25);
    
    scale.setThickness(0.8);
    scale.setAlignment(cfx.StringAlignment.Near);

    var tickmarks = scale.getTickmarks();
    var major = tickmarks.getMajor();
    major.setVisible(true);
    major.setSize(0.1);
    major.setStyle(cfx.gauge.TickmarkStyle.Line);
    major.setWidth(0.025);
    major.setPosition(0.75);
    tickmarks.getMedium().setVisible(false);

    var mainIndicator = gauge.getMainIndicator();
    mainIndicator.setSize(0.35);
    mainIndicator.setPosition(0.325);

    bar.setTemplate(gaugeTemplates.auroraLinearBar);

    scale.setAllowHalves(false);

    var styleInfo = aurora.getStyleInfo(args);
 
    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.8);
        scale.setPosition(0);
        mainIndicator.setSize(0.25);
        mainIndicator.setPosition(0.375);
        mainIndicator.setTitle("Current");
        var target = new cfx.gauge.Marker();
        target.setSize(0.4);
        target.setPosition(0.5);
        target.setTitle("Target");
        var targetTemplate = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib"><DataTemplate.Resources><sys:String x:Key="ratio">0.1</sys:String></DataTemplate.Resources><Viewbox ViewWidth="25" ViewHeight="50"><Grid><Canvas><Border Fill="{Binding Path=Fill}" CornerRadius="5"/><Border Stroke="#11333333" StrokeThickness="2" CornerRadius="5"/></Canvas></Grid></Viewbox></DataTemplate>';
        target.setTemplate(targetTemplate);
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

aurora.vert = function aurora$vert(gauge, args)
{
    aurora.linear(gauge, args);
}

aurora.horz = function aurora$horz(gauge, args)
{
    aurora.linear(gauge, args);
    gauge.getMainScale().setThickness(0.9);
}

aurora.chart = function aurora$chart(chart, args)
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
    yGrids.getMajor().setTickMark(cfx.TickMark.Cross);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);

    yGrids = chart.getAxisY2().getGrids();
    yGrids.getMajor().setTickMark(cfx.TickMark.Cross);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);
 
    var xGrids = chart.getAxisX().getGrids();
    xGrids.getMinor().setTickMark(cfx.TickMark.None);
    xGrids.getMajor().setTickMark(cfx.TickMark.Outside);

    xGrids.getMajor().setStyle(xGrids.getMajor().getStyle() | cfx.AxisStyles.Centered);

    chart.getAxisX().getLine().setWidth(2);
    chart.getAllSeries().getBorder().setUseForLines(false);
    chart.getAxisX().getGrids().getMajor().setTickMark(cfx.TickMark.Outside);
    chart.getAllSeries().setMarkerShape(cfx.MarkerShape.Rect);

    chart.setFont("8pt 'Roboto', sans-serif");
}

aurora.map = function aurora$map(map, args) {
    map.setShowAdditionalLayers(false);
}

aurora.heatmap = function aurora$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#329287");
    gradients.getItem(1).setColor("#75AE50");
}

aurora.equalizer = function aurora$equalizer(equalizer, args) {
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#477EA5");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#75AE50");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#3350525D");
}

aurora.trend = function aurora$trend(trend, args)
{
    trend.getSecondaryValues().setAlphaForeground(.3);
    trend.getDelta().setVisible(false);
    var secondaryValues = trend.getSecondaryValues();
    secondaryValues.setSeparatorWidth(0.1);
    var indicator = trend.getIndicator();
    indicator.setStyle(cfx.gauge.IndicatorStyle.TriangleVertical);

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

aurora.border = function aurora$border(border, args)
{
}

})();