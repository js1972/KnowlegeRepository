(function () {

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "healthy";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.healthyDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                          '<Border Background="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" Margin="2">' +
                            '<Grid Margin="1">' +
                              '<Grid.RowDefinitions>' +
                                '<RowDefinition Height="Auto" MinHeight="32"/>' +
                                '<RowDefinition Height="*"/>' +
                              '</Grid.RowDefinitions>' +
                              '<Border Background="{Binding Path=Fill}" Stroke="{x:Null}">' +
                                '<TextBlock Margin="21,18,21,8" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="11" FontWeight="Normal" />' +
                              '</Border>' +
                              '<Border Grid.Row="1" Background="{Binding Path=Fill}" BorderBrush="{x:Null}">' +
                              '<Canvas x:Name="targetChart" Margin="4,4,4,10"/>' +
                              '</Border>' +
                            '</Grid>' +
                        '</Border>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.healthyRadialDashBorder = "<DataTemplate/>";

    gaugeTemplates.healthyRadialIndicator = "NeedleRegularDrop";

    gaugeTemplates.healthyRadialSection = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
            '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
            '<Path Data="{Binding Path=GeometryInside}" Stroke="{Binding Path=Stroke}" />' +
       '</Canvas>' +
      '</DataTemplate>';

    gaugeTemplates.healthyRadialCap = '<DataTemplate><Ellipse Fill="#E9E9E9" /><Ellipse><Ellipse.Fill><RadialGradientBrush><GradientStop Color="#00FFFFFF" Offset="0"/><GradientStop Color="#00FFFFFF" Offset="0.7"/><GradientStop Color="#88FFFFFF" Offset="0.9"/><GradientStop Color="#66AAAAAA" Offset="1"/></RadialGradientBrush></Ellipse.Fill></Ellipse></DataTemplate>';

    gaugeTemplates.healthyRadialGlare = '<DataTemplate/>';

    gaugeTemplates.healthyLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.healthyLinearGlare = '<DataTemplate/>';

    gaugeTemplates.healthyLinearFiller = "LinearFillerSimple";

    gaugeTemplates.healthyLinearMarker = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                '<DataTemplate.Resources>' +
                    '<sys:String x:Key="ratio">0.2</sys:String>' +
                '</DataTemplate.Resources>' +
                '<Canvas Margin="0">' +
                      '<Border Fill="{Binding Path=Fill}" CornerPercent="1" />' +
                      '<Border Stroke="{Binding Path=Stroke}" StartCorner="1" Segments="1" CornerPercent="1" />' +
                '</Canvas>' +
            '</DataTemplate>';

    gaugeTemplates.healthyLinearBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
          '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.healthyLinearBarRound = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerPercent="1" />' +
          '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.healthyVerticalFillerRound = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerPercent="1" />' +
          '<Border Stroke="{Binding Path=Stroke}" StartCorner="1" Segments="1" CornerPercent="1" />' +
          '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.healthyHorizontalFillerRound = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerPercent="1" />' +
          '<Border Stroke="{Binding Path=Stroke}" StartCorner="2" Segments="1" CornerPercent="1" />' +
          '</Canvas>' +
        '</DataTemplate>';

    gaugeTemplates.healthyRadialBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
          '<Path Data="{Binding Path=GeometryRound}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
        '</Canvas>' +
      '</DataTemplate>';

    gaugeTemplates.healthyRadialFillerRound = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
          '<Path Data="{Binding Path=GeometryRound}" Fill="{Binding Path=Fill}" />' +
          '<Path Data="{Binding Path=GeometryInside}" Stroke="{Binding Path=Stroke}" />' +
        '</Canvas>' +
      '</DataTemplate>';

    
    gaugeTemplates.healthyLinearSection = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<DataTemplate x:Key="firstSection">' +
                '<Path Data="{Binding Path=GeometryRoundStart}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="middleSection">' +
                '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="lastSection">' +
                '<Path Data="{Binding Path=GeometryRoundEnd}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
        '</DataTemplate.Resources>' +
        '<Path Data="{Binding Path=GeometryRound}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
        '</DataTemplate>';

    gaugeTemplates.healthyRadialSection = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<DataTemplate x:Key="firstSection">' +
                '<Path Data="{Binding Path=GeometryRoundStart}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="middleSection">' +
                '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="lastSection">' +
                '<Path Data="{Binding Path=GeometryRoundEnd}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
            '</DataTemplate>' +
        '</DataTemplate.Resources>' +
        '<Path Data="{Binding Path=GeometryRound}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}"/>' +
        '</DataTemplate>';

    var gaugePalette = new cfx.gauge.Palette();
    gaugePalette.setColors([
        "#CCCCCC",   // Dashboard Back
        "#FFFFFF",   // Dashboard Inside
        "#808080",   // Border Back
        "#F0F0F0",   // Border Inside
        "#999999",   // Indicator
        "#999999",   // Indicator Border
        "#F47528",   // Filler
        "#B7581E",   // Filler Border
        "#0000FF",   // Cap
        "#FF0000",   // Cap Border
        "#828282",   // Scale
        "#E9E9E9",   // Bar Back
        null,        // Bar Border
        null,        // Bar Alternate
        "#ED3B6B",   // Section Back 0
        "#B22D51",   // Section Border 0
        null,   // Section Alternate 0
        "#FDD25F",   // Section Back 1
        "#BE9E48",   // Section Border 1
        null,    // Section Alternate 1
        "#A8D350",   // Section Back 2
        "#7E9F3C",   // Section Border 2
        null,    // Section Alternate 2
        "#BBBBBB",   // Tickmark
        "#BBBBBB",   // Tickmark Inside
        "#48494D",   // Title
        "#48494D",   // Title Docked
        "#808080",   // Caption
        "#8A8B8F",   // Trend
        "#ED3B6B",   // Conditional Less
        "#FDD25F",   // Conditional Equal
        "#A8D350",   // Conditional Greater
        "#999999",   // ToolTipText
        "#ffffff",   // ToolTipBack
        "#999999"    // ToolTipBorder
    ]);

    cfx.gauge.Palette.setDefaultPalette(gaugePalette);
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["BorderEffect2.fill"] = "0,#E9E9E9";
    chartTemplates["DashboardTitle.fill"] = "0,#48494D";
    chartTemplates["DashboardTitle.font-family"] = "1,Arial";
    chartTemplates["AxisY_Text.fill"] = "0,#8A8B8F";

    chartTemplates.healthyBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
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
                        '<Border Background="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" Margin="2">' +
                            '<Grid Margin="1">' +
                              '<Grid.RowDefinitions>' +
                                '<RowDefinition Height="Auto" MinHeight="32"/>' +
                                '<RowDefinition Height="*"/>' +
                              '</Grid.RowDefinitions>' +
                              '<Border Background="{Binding Path=Fill}" BorderBrush="{x:Null}">' +
                                '<TextBlock Margin="21,18,21,8" Text="{Binding Path=Title}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="11" FontWeight="Normal" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}"/>' +
                              '</Border>' +
                              '<Border Grid.Row="1" Background="{Binding Path=Fill}" BorderBrush="{x:Null}">' +
                              '<Canvas x:Name="targetChart" Margin="20,0,0,0"/>' +
                              '</Border>' +
                            '</Grid>' +
                        '</Border>' +
                      '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.healthyBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<DataTemplate x:Key="cfxLastStack">' +
                '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerRadius="200,200,0,0" CornerPercent="1" />' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="cfxFirstStack">' +
                '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
            '</DataTemplate>' +
        '</DataTemplate.Resources>' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerRadius="200,200,0,0" CornerPercent="1" />' +
          '</Canvas>' +
        '</DataTemplate>';

    chartTemplates.healthyGantt = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<DataTemplate x:Key="cfxLastStack">' +
                '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerRadius="0,200,200,0" CornerPercent="1" />' +
            '</DataTemplate>' +
            '<DataTemplate x:Key="cfxFirstStack">' +
                '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
            '</DataTemplate>' +
        '</DataTemplate.Resources>' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerRadius="0,200,200,0" CornerPercent="1" />' +
          '</Canvas>' +
        '</DataTemplate>';

    chartTemplates.healthyEqualizer = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" CornerRadius="10" CornerPercent="0.75" />' +
          '</Canvas>' +
        '</DataTemplate>';

    chartTemplates.healthyArea = "AreaBasic";

    chartTemplates.healthyLine = "LineBasic";

    chartTemplates.healthyCurveArea = "CurveAreaBasic";

    chartTemplates.healthyCurve = "CurveBasic";

    chartTemplates.healthyPie = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
    '<DataTemplate.Resources>' +
    '</DataTemplate.Resources>' +
    '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
    '<Path Data="{Binding Path=Geometry}" Stroke="{Binding Class=BorderEffect2.fill}" StrokeThickness="3" />' +
    '</DataTemplate>';

    chartTemplates.healthyDoughnut = chartTemplates.healthyPie;

    chartTemplates.healthyBubble = "BubbleBasic";

    chartTemplates.healthyTreeMap = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Border Margin="1" Background="{Binding Path=Fill}" BorderBrush="{x:Null}" CornerRadius="8"/>' +
        '<Border Margin="1" Background="#88FFFFFF" BorderBrush="{x:Null}" CornerRadius="8"/>' +
        '<Border Margin="5" Background="{Binding Path=Fill}" BorderBrush="{x:Null}" />' +
        '</DataTemplate>';

    chartTemplates.healthyFunnel = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
        '<Polygon Points="{Binding Path=PointsPolygon}" Fill="{Binding Path=Fill}" />' +
        '<Polygon Points="{Binding Path=PointsPolygon}" Stroke="{Binding Class=BorderEffect2.fill}" StrokeThickness="3" />' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.healthyPyramid = chartTemplates.healthyFunnel;

    chartTemplates.healthySparklineLine = chartTemplates.healthyLine;

    chartTemplates.healthySparklineBar = chartTemplates.healthyBar;

    chartTemplates.healthySparklineArea = chartTemplates.healthyArea;

    chartTemplates.healthyBullet = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                    '<DataTemplate.Resources>' +
                      '<DataTemplate x:Key="templateLine">' +
                        '<Line X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}" Stroke="{Binding Path=Stroke}" StrokeThickness="3" />' +
                      '</DataTemplate>' +
                    '</DataTemplate.Resources>' +
                    '<Canvas>' +
                    '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" CornerRadius="0,200,200,0" CornerPercent="1" />' +
                    '</Canvas>' +
                    '</DataTemplate>';

    var chartPalette = new cfx.Palette();
    chartPalette.setColors([
        "#A8D350",   // Series 0
        "#FDD25F",   // Series 1
        "#F47528",   // Series 2
        "#ED3B6B",   // Series 3
        "#4EC2C2",   // Series 4
        "#3399FE",   // Series 5
        "#909090",   // Series 6
        "#FF4488",   // Series 7
        "#FFBD21",   // Series 8
        "#A9DFDF",   // Series 9
        "#FFA4C7",   // Series 10
        "#54C1C6",   // Series 11
        "#D04500",   // Series 12
        "#F99803",   // Series 13
        "#78C817",   // Series 14
        "#1365D7",   // Series 15
        "#FFFFFF",   // Background
        "#F0F0F0",   // AlternateBackground
        "#00000000", // InsideBackground
        "#CCCCCC",   // Border
        "#BBBBBB",   // AxesAndGridlines
        "#F3F3F3",   // AxesAlternate
        "#54C1C6",   // CustomGridLines
        "#C5E8E8",   // AxisSections
        "#8A8B8F",   // AxisLabels
        "#8A8B8F",   // PointLabels
        "#00000000", // MarkerBorder
        "#48494D",   // TitlesFore
        "#00000000", // TitlesBack
        "#A8A8A8",   // LegendText
        "#00000000", // LegendBackground
        "#ffffff",   // DataBack
        "#8A8B8F",   // DataFore
        "#F3F3F3",   // DataBackAlternate
        "#8A8B8F",   // DataForeAlternate
        "#E7E7E7",   // DataTitlesBack
        "#8A8B8F",   // DataTitlesFore
        "#E7E7E7",   // DataGridlines
        "#ffffff",   // DataBackground
        "#999999",   // ToolTipText
        "#ffffff",   // ToolTipBack
        "#999999"    // ToolTipBorder
    ]);
    cfx.Chart.setDefaultPalette(chartPalette);
}


var healthy = function healthy()
{
}

cfx.motifs.healthy = healthy;

healthy.getStyleInfo = function healthy$global(args)
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

healthy.global = function healthy$global(gauge) {
    gauge.setFont("12pt Arial");
    gauge.getToolTips().setBorderTemplate('<DataTemplate xmlns:x="a"><DataTemplate.Resources><MultiplyConverter x:Key="multConverter"/></DataTemplate.Resources><Canvas Padding="12"><Border Stroke="{Binding Path=Stroke}" StrokeThickness="3" CornerRadius="45" CornerPercent="1" Canvas.Top="2" Segments="7" StartCorner="2"></Border><Border BorderBrush="{Binding Path=Stroke}" BorderThickness="2" Background="{Binding Path=Fill}" CornerPercent="1" CornerRadius="45" Padding="4" Segments="7" StartCorner="2"><DockPanel x:Name="container" Margin="10,10,10,6" Orientation="Vertical"><TextBlock Text="{Binding Path=Title}" FontSize="{Binding Path=FontSize, Converter={StaticResource multConverter},ConverterParameter=0.8}" Visible="{Binding Path=TitleVisible}" HorizontalAlignment="Right" FontWeight="Bold" Margin="3,0,3,0"/><Border Height="1" Stroke="{Binding Path=Foreground}" StrokeThickness="1" Margin="0,0,0,4" Visible="{Binding Path=TitleVisible}"/></DockPanel></Border></Canvas></DataTemplate>');
}

healthy.radial = function healthy$radial(gauge, args)
{
    healthy.global(gauge);
 
    var styleInfo = healthy.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);

    var mainScale = gauge.getMainScale();
    var mainIndicator = gauge.getMainIndicator();
    mainIndicator.setUseSectionColor(true);

    if (styleInfo.name == "progress") {
        mainScale.setThickness(1.3);
        mainScale.setPosition(-0.1);

        var bar = mainScale.getBar();
        bar.setVisible(true);
        bar.setTemplate(gaugeTemplates.healthyRadialBar);
        bar.setThickness(0.25);

        mainScale.setStartAngle(130);
        mainScale.setSweepAngle(280);

        var filler = new cfx.gauge.Filler();
        filler.setTemplate(gaugeTemplates.healthyRadialFillerRound);
        filler.setPosition(0.17);
        filler.setSize(0.21);
        gauge.setMainIndicator(filler);

        var defaultAttributes = gauge.getDefaultAttributes();
        defaultAttributes.setSectionPosition(0.18);
        defaultAttributes.setSectionThickness(0.05);
    }
    else {
        mainScale.setThickness(0.7);
        mainScale.setPosition(0);
        var bar = mainScale.getBar();
        bar.setVisible(true);
        bar.setTemplate(gaugeTemplates.healthyRadialBar);
        bar.setThickness(0.6);
        bar.setPosition(0.35);

        var cap = mainScale.getCap();
        cap.setSize(0.13);

        mainScale.setStartAngle(180);
        mainScale.setSweepAngle(180);

        mainIndicator.setSize(0.5);
        mainIndicator.setPosition(0.75);

        var tickmarks = mainScale.getTickmarks();
        var major = tickmarks.getMajor();
        major.setWidth(0.01);
        major.setSize(0.05);
        major.setPosition(-0.05);
        mainScale.setAlignment(cfx.StringAlignment.Near);
        major.setStyle(cfx.gauge.TickmarkStyle.None);
        tickmarks.getMedium().setVisible(false);

        var defaultAttributes = gauge.getDefaultAttributes();
        defaultAttributes.setSectionPosition(0.4);
        defaultAttributes.setSectionThickness(0.5);
    }
}

healthy.linear = function healthy$linear(gauge, args)
{
    healthy.global(gauge);
    var scale = gauge.getMainScale();
    var bar = scale.getBar();

    bar.setVisible(true);
    scale.setThickness(0.75);
    scale.setAlignment(cfx.StringAlignment.Near);

    var tickmarks = scale.getTickmarks();
    var major = tickmarks.getMajor();
    major.setSize(0.1);
    major.setStyle(cfx.gauge.TickmarkStyle.Line);
    major.setWidth(0.025);
    major.setPosition(0.75);
    tickmarks.getMedium().setVisible(false);

    bar.setThickness(0.5);
    bar.setPosition(0.25);

    var mainIndicator = gauge.getMainIndicator();
    mainIndicator.setSize(0.4);
    mainIndicator.setPosition(0.3);

    gauge.setFont("9pt 'Fira Sans', Arial");

    bar.setTemplate(gaugeTemplates.healthyLinearBarRound);

    scale.setAllowHalves(false);

    var styleInfo = healthy.getStyleInfo(args);
 
    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.9);
        scale.setPosition(0);
        mainIndicator.setSize(0.25);
        mainIndicator.setPosition(0.375);
        mainIndicator.setTitle("Current");
        var target = new cfx.gauge.Marker();
        target.setSize(0.4);
        target.setPosition(0.5);
        target.setTitle("Target");
        target.setTemplate(gaugeTemplates.healthyLinearMarker);
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

healthy.vert = function healthy$vert(gauge, args)
{
    healthy.linear(gauge, args);

    var mainIndicator = gauge.getMainIndicator();
    mainIndicator.setTemplate(gaugeTemplates.healthyVerticalFillerRound);
}

healthy.horz = function healthy$horz(gauge, args)
{
    healthy.linear(gauge, args);

    var styleInfo = healthy.getStyleInfo(args);

    var mainIndicator = gauge.getMainIndicator();
    mainIndicator.setTemplate(gaugeTemplates.healthyHorizontalFillerRound);

    if (!styleInfo.isBullet) {
        gauge.getMainScale().setThickness(0.5);
    }
}

healthy.chart = function healthy$chart(chart, args)
{
    var gallery = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            gallery = t[0];
        }
    }

    chart.getAllSeries().setMarkerSize(1);

    if (gallery != undefined) {
        gallery = gallery.toUpperCase();

        if (gallery == "GROUP") {
            chart.getBorder().setTemplate('<DataTemplate/>');
        }
    }

    var yGrids = chart.getAxisY().getGrids();
    yGrids.getMajor().setTickMark(cfx.TickMark.None);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);

    yGrids = chart.getAxisY2().getGrids();
    yGrids.getMajor().setTickMark(cfx.TickMark.None);
    yGrids.getMinor().setTickMark(cfx.TickMark.None);
 
    var xGrids = chart.getAxisX().getGrids();
    xGrids.getMinor().setTickMark(cfx.TickMark.None);
    xGrids.getMajor().setTickMark(cfx.TickMark.Outside);

    xGrids.getMajor().setStyle(xGrids.getMajor().getStyle() | cfx.AxisStyles.Centered);

    chart.getAllSeries().setMarkerStyle(cfx.MarkerStyle.Filled);

    chart.getAllSeries().getBorder().setUseForLines(false);

    chart.getAxisX().getGrids().getMajor().setTickMark(cfx.TickMark.Outside);

    chart.getAllSeries().getLine().setWidth(2);

    chart.setFont("9pt 'Fira Sans', Arial");

    chart.getToolTips().setBorderTemplate('<DataTemplate xmlns:x="a"><DataTemplate.Resources><MultiplyConverter x:Key="multConverter"/></DataTemplate.Resources><Canvas Padding="12"><Border BorderBrush="{Binding Path=ItemFillS}" BorderThickness="3" CornerRadius="45" CornerPercent="1" Canvas.Top="2" Segments="7" StartCorner="2"></Border><Border BorderBrush="{Binding Path=ItemFillS}" BorderThickness="2" Background="{Binding Path=Fill}" CornerPercent="1" CornerRadius="45" Padding="4" Segments="7" StartCorner="2"><DockPanel x:Name="container" Margin="10,10,10,6" Orientation="Vertical"><TextBlock Text="{Binding Path=Title}" FontSize="{Binding Path=FontSize, Converter={StaticResource multConverter},ConverterParameter=0.8}" Visible="{Binding Path=TitleVisible}" HorizontalAlignment="Right" FontWeight="Bold" Margin="3,0,3,0"/><Border Height="1" Stroke="{Binding Path=Foreground}" StrokeThickness="1" Margin="0,0,0,4" Visible="{Binding Path=TitleVisible}"/></DockPanel></Border></Canvas></DataTemplate>');
}

healthy.map = function healthy$map(map, args)
{
    map.setShowAdditionalLayers(false);
    var mapLayer = new cfx.maps.MapLayer();
    mapLayer.setPath("@main");
    var shadow = mapLayer.getShadow();
    shadow.setXOffset(4);
    shadow.setYOffset(4);
    shadow.setColor("#E9E9E9");
    map.getLayers().add(mapLayer);
}

healthy.heatmap = function healthy$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#A8D350");
    gradients.getItem(1).setColor("#FDD25F");
}

healthy.equalizer = function healthy$equalizer(equalizer, args) {
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#FDD25F");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F47528");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#33BBBBBB");
}

healthy.trend = function healthy$trend(trend, args)
{
    trend.getSecondaryValues().setAlphaForeground(1);
    trend.getDelta().setVisible(false);
    var secondaryValues = trend.getSecondaryValues();
    secondaryValues.setSeparatorWidth(0);
    var indicator = trend.getIndicator();
    indicator.setStyle(cfx.gauge.IndicatorStyle.ArrowVerticalPointer);
    indicator.setPosition(cfx.gauge.IndicatorPosition.Primary);

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

healthy.border = function healthy$border(border, args)
{
}

})();