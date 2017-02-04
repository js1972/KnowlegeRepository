(function(){

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "lizard";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.lizardDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                            '<Border Background="{Binding Path=Fill}" />' +
                            '<Grid>' +
                              '<Grid.RowDefinitions>' +
                                '<RowDefinition Height="Auto" MinHeight="32"/>' +
                                '<RowDefinition Height="*"/>' +
                              '</Grid.RowDefinitions>' +
                              '<Border Background="#33222222">' +
                                '<TextBlock Margin="8,0" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="9" FontWeight="Bold"/>' +
                              '</Border>' +
                              '<Border Grid.Row="1" Background="{Binding Path=Fill}">' +
                              '<Canvas x:Name="targetChart" Margin="8,16,8,8"/>' +
                              '</Border>' +
                            '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.lizardRadialDashBorder = "<DataTemplate/>";

    gaugeTemplates.lizardRadialIndicator = "NeedleRegularDrop";

    gaugeTemplates.lizardRadialCap = '<DataTemplate><Ellipse Stroke="#F19024" StrokeThickness="2" Fill="{x:Null}"/></DataTemplate>';

    gaugeTemplates.lizardRadialGlare = '<DataTemplate/>';

    gaugeTemplates.lizardLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.lizardLinearGlare = '<DataTemplate/>';

    gaugeTemplates.lizardLinearFiller = "LinearFillerSimple";

    gaugeTemplates.lizardRadialBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
            '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" />' +
            '<Path Data="{Binding Path=GeometryOutside}" Stroke="#66000000" />' +
            '<Path Data="{Binding Path=GeometryInside}" Stroke="#22FFFFFF" />' +
            '<Path Data="{Binding Path=GeometryStart}" Stroke="#22FFFFFF" />' +
            '<Path Data="{Binding Path=GeometryEnd}" Stroke="#22FFFFFF" />' +
            '</Canvas>' +
      '</DataTemplate>';

    gaugeTemplates.lizardLinearBar = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas Margin="0">' +
          '<Border Fill="{Binding Path=Fill}" Stroke="{x:Null}" CornerRadius="2" />' +
          '<Border Fill="{x:Null}" StrokeThickness="1" Stroke="#66000000" StartCorner="3" Segments="2" CornerRadius="2" />' +
          '<Border Fill="{x:Null}" StrokeThickness="1" Stroke="#22DDDDDD" StartCorner="1" Segments="2" CornerRadius="2" />' +
          '</Canvas>' +
        '</DataTemplate>';

    var gaugePalette = new cfx.gauge.Palette();
    gaugePalette.setColors([
        "#2A2A2A",   // Dashboard Back
        "#2A2A2A",   // Dashboard Inside
        "#2A2A2A",   // Border Back
        "#2A2A2A",   // Border Inside
        "#707275",   // Indicator
        "#707275",   // Indicator Border
        "#707275",   // Filler
        "#707275",        // Filler Border
        "#606060",   // Cap
        null,   // Cap Border
        "#D3D4D4",   // Scale
        "#1A1C1D",   // Bar Back 
        "#101010",   // Bar Border 
        null,   // Bar Alternate 
        "#AF432D",   // Section Back 0
        "#A1412D",   // Section Border 0
        null,   // Section Alternate 0
        "#B6722D",   // Section Back 1
        "#A86A2C",   // Section Border 1
        null,   // Section Alternate 1
        "#76AB05",   // Section Back 2
        "#6E9E08",    // Section Border 2
        null,    // Section Alternate 2
        "#D3D4D4",   // Tickmark
        "#D3D4D4",   // Tickmark Inside
        "#D3D4D4",   // Title
        "#D3D4D4",   // Title Docked
        "#808080",   // Caption
        "#D3D4D4",   // Trend
        "#AF432D",   // Conditional Less
        "#B6722D",        // Conditional Equal
        "#76AB05",   // Conditional Greater
        "#333333",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#333333"    // ToolTipBorder
    ]);

    cfx.gauge.Palette.setDefaultPalette(gaugePalette);
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardTitle.fill"] = "0,#8B8B8B";
    chartTemplates["DashboardTitle.font-family"] = "1,Helvetica, Arial, sans-serif";
    chartTemplates["AxisY_Text.fill"] = "0,#606060";
    chartTemplates["Border.fill"] = "0,#2A2A2A";

    chartTemplates.lizardBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                        '<Thickness x:Key="externalMargin">16</Thickness>' +
                        '<Thickness x:Key="internalRectMargin">2</Thickness>' +
                        '<DataTemplate x:Key="internalRect">' +
                          '<Border CornerRadius="6" Background="{Binding Path=Fill}" BorderBrush="{Binding Path=Stroke}" CornerPercent="0.5" />' +
                        '</DataTemplate>' +
                        '<DataTemplate x:Key="internal">' +
                          '<Line Stroke="{Binding Path=Stroke}" X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}"/>' +
                        '</DataTemplate>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                        '<Border Background="{Binding Path=Fill}" />' +
                            '<Grid>' +
                              '<Grid.RowDefinitions>' +
                                '<RowDefinition Height="Auto" MinHeight="32"/>' +
                                '<RowDefinition Height="*"/>' +
                              '</Grid.RowDefinitions>' +
                              '<Border Background="#33222222">' +
                                '<TextBlock Margin="8,0" Text="{Binding Path=Title}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="9" FontWeight="Bold" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardTitle.fill}"/>' +
                              '</Border>' +
                              '<Border Grid.Row="1" Background="{x:Null}">' +
                              '<Canvas x:Name="targetChart" Margin="8"/>' +
                              '</Border>' +
                            '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    chartTemplates.lizardBar = "BarBasic";

    chartTemplates.lizardGantt = "GanttBasic";

    chartTemplates.lizardEqualizer = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                  '<Border Background="{Binding Path=Fill}" />' +
            '</DataTemplate>';

    chartTemplates.lizardArea = "AreaBasic";

    chartTemplates.lizardCurveArea = "CurveAreaBasic";

    chartTemplates.lizardLine = "LineBasic";

    chartTemplates.lizardCurve = "CurveBasic";

    chartTemplates.lizardPie = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
    '<DataTemplate.Resources>' +
      '<DataTemplate x:Key="cfxRay">' +
         '<Line X1="{Binding Path=X1}" Y1="{Binding Path=Y1}" X2="{Binding Path=X2}" Y2="{Binding Path=Y2}" Stroke="{Binding Class=Border.fill}" StrokeThickness="2"/>' +
      '</DataTemplate>' +
    '</DataTemplate.Resources>' +
    '<Path Data="{Binding Path=Geometry}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
    '</DataTemplate>';

    chartTemplates.lizardDoughnut = chartTemplates.lizardPie;

    chartTemplates.lizardBubble = "BubbleBasic";

    chartTemplates.lizardTreeMap = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
            '<Canvas Margin="1">' +
            '<Border Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
            '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.lizardFunnel = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Polygon Points="{Binding Path=PointsPolygon}" Fill="{Binding Path=Fill}" Stroke="{Binding Path=Stroke}" />' +
    '</DataTemplate>';

    chartTemplates.lizardPyramid = chartTemplates.lizardFunnel;

    chartTemplates.lizardSparklineLine = chartTemplates.lizardLine;

    chartTemplates.lizardSparklineBar = chartTemplates.lizardBar;

    chartTemplates.lizardSparklineArea = chartTemplates.lizardArea;

    chartTemplates.lizardMarker1 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
            '<Rectangle Fill="{Binding Path=Fill}" />' +
            '<Rectangle Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker2 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
            '<Ellipse Fill="{Binding Path=Fill}" />' +
            '<Ellipse Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker3 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M12,1L24,22L0,22L12,1" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M12,1L24,22L0,22L12,1" Stroke="{Binding Class=Border.fill}" StrokeThickness="3" />' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker4 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M24,12L18,18L12,24L6,18L0,12L6,6L12,0L18,6L24,12" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M24,12L18,18L12,24L6,18L0,12L6,6L12,0L18,6L24,12" Stroke="{Binding Class=Border.fill}" StrokeThickness="3" />' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker5 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<Canvas>' +
            '<Ellipse Fill="{Binding Path=Fill}" />' +
            '<Ellipse Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
            '<Ellipse>' +
                '<Ellipse.Fill>' +
                    '<RadialGradientBrush>' +
                        '<GradientStop Color="#55FFFFFF" Offset="0"/>' +
                        '<GradientStop Color="#55333333" Offset="1"/>' +
                    '</RadialGradientBrush>' +
                '</Ellipse.Fill>' +
            '</Ellipse>' +
        '</Canvas>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker6 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M24,9L0,9L0,15L24,15L24,9" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M24,9L0,9L0,15L24,15L24,9" Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker7 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M15,24L15,0L9,0L9,24L15,24" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M15,24L15,0L9,0L9,24L15,24" Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker8 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M24,9L15,9L15,0L9,0L9,9L0,9L0,15L9,15L9,24L15,24L15,15L24,15L24,9" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M24,9L15,9L15,0L9,0L9,9L0,9L0,15L9,15L9,24L15,24L15,15L24,15L24,9" Stroke="{Binding Class=Border.fill}" StrokeThickness="2"/>' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker9 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M12,24L24,0L0,0L12,24" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M12,24L24,0L0,0L12,24" Stroke="{Binding Class=Border.fill}" StrokeThickness="3"/>' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    chartTemplates.lizardMarker10 = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
            '<sys:Double x:Key="cfxOSW">1</sys:Double>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="25" ViewHeight="25">' +
            '<Canvas>' +
                '<Path Data="M20.485,17.657L14.828,12l5.657-5.657c0.781-0.781,0.781-2.047,0-2.829c-0.781-0.781-2.048-0.781-2.828,0L12,9.172L6.343,3.515c-0.78-0.781-2.047-0.781-2.828,0c-0.781,0.781-0.781,2.048,0,2.829L9.172,12l-5.657,5.657c-0.781,0.78-0.781,2.047,0,2.828s2.048,0.781,2.828,0L12,14.828l5.656,5.657c0.781,0.781,2.048,0.781,2.829,0C21.266,19.704,21.267,18.438,20.485,17.657z" Fill="{Binding Path=Fill}" />' +
                '<Path Data="M20.485,17.657L14.828,12l5.657-5.657c0.781-0.781,0.781-2.047,0-2.829c-0.781-0.781-2.048-0.781-2.828,0L12,9.172L6.343,3.515c-0.78-0.781-2.047-0.781-2.828,0c-0.781,0.781-0.781,2.048,0,2.829L9.172,12l-5.657,5.657c-0.781,0.78-0.781,2.047,0,2.828s2.048,0.781,2.828,0L12,14.828l5.656,5.657c0.781,0.781,2.048,0.781,2.829,0C21.266,19.704,21.267,18.438,20.485,17.657z" Stroke="{Binding Class=Border.fill}" StrokeThickness="2" />' +
            '</Canvas>' +
        '</Viewbox>' +
    '</DataTemplate>';

    var chartPalette = new cfx.Palette();
    chartPalette.setColors([
        "#258DC8",   // Series 0
        "#4EB42E",   // Series 1
        "#F15619",   // Series 2
        "#80699B",   // Series 3
        "#77AB14",   // Series 4
        "#B5712E",   // Series 5
        "#AE432E",   // Series 6
        "#B8B300",   // Series 7
        "#0D233A",   // Series 8
        "#BD1700",   // Series 9
        "#FF9800",   // Series 10
        "#965994",   // Series 11
        "#910000",   // Series 12
        "#8BBC21",   // Series 13
        "#2F7ED8",   // Series 14
        "#BB7C00",   // Series 15
        "#2A2A2A",   // Background
        "#F0F0F0",   // AlternateBackground
        "#00000000", // InsideBackground
        "#2A2A2A",   // Border
        "#C0C0C0",   // AxesAndGridlines
        "#1A1A1A",   // AxesAlternate
        "#fc4b35",   // CustomGridLines
        "#ffffff",   // AxisSections
        "#606060",   // AxisLabels
        "#606060",   // PointLabels
        "#00000000", // MarkerBorder
        "#6D869F",   // TitlesFore
        "#00000000", // TitlesBack
        "#5B5B5B",   // LegendText
        "#00000000", // LegendBackground
        "#2A2A2A",   // DataBack
        "#606060",   // DataFore
        "#1A1A1A",   // DataBackAlternate
        "#606060",   // DataForeAlternate
        "#272727",   // DataTitlesBack
        "#8B8B8B",   // DataTitlesFore
        "#606060",   // DataGridlines
        "#2A2A2A",   // DataBackground
        "#333333",   // ToolTipText
        "#FFFFFF",   // ToolTipBack
        "#333333"    // ToolTipBorder
    ]);
    cfx.Chart.setDefaultPalette(chartPalette);
}


var lizard = function lizard()
{
}

cfx.motifs.lizard = lizard;

lizard.getStyleInfo = function lizard$global(args)
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

lizard.global = function lizard$global(gauge) {
    gauge.setFont("8pt Arial");
    gauge.getToolTips().setBorderTemplate('<DataTemplate xmlns:x="a"><DataTemplate.Resources><MultiplyConverter x:Key="multConverter"/></DataTemplate.Resources><Canvas Padding="12"><Border BorderBrush="{Binding Path=Stroke}" BorderThickness="2" Background="{Binding Path=Fill}" Opacity="0.85" CornerPercent="0.4" CornerRadius="8" Padding="4,4,4,0"><DockPanel x:Name="container" Orientation="Vertical"><TextBlock Text="{Binding Path=Title}" FontSize="{Binding Path=FontSize, Converter={StaticResource multConverter},ConverterParameter=0.8}" Visible="{Binding Path=TitleVisible}" HorizontalAlignment="Right" FontWeight="Bold" Margin="3,0,3,0"/><Border Height="1" Stroke="{Binding Path=Foreground}" StrokeThickness="1" Margin="0,0,0,4" Visible="{Binding Path=TitleVisible}"/></DockPanel></Border></Canvas></DataTemplate>');
}

lizard.radial = function lizard$radial(gauge, args)
{
    lizard.global(gauge);
 
    var styleInfo = lizard.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);

    var mainScale = gauge.getMainScale();
    if (styleInfo.name == "progress") {
        mainScale.setThickness(1);
        mainScale.setPosition(0);
        mainScale.setStartAngle(180);
        mainScale.setSweepAngle(180);
    }
    else {
        mainScale.setThickness(1);
        mainScale.setPosition(0);
        var bar = mainScale.getBar();
        bar.setVisible(true);
        bar.setTemplate(gaugeTemplates.lizardRadialBar);
        bar.setThickness(0.7);
        bar.setPosition(0.15);

        var cap = mainScale.getCap();
        cap.setVisible(false);
        mainScale.setStartAngle(205);
        mainScale.setSweepAngle(130);

        var mainIndicator = gauge.getMainIndicator();
        mainIndicator.setSize(0.8);
        mainIndicator.setPosition(1);

        var tickmarks = mainScale.getTickmarks();
        tickmarks.getMajor().setVisible(false);
        tickmarks.getMedium().setVisible(false);

        var defaultAttributes = gauge.getDefaultAttributes();
        defaultAttributes.setSectionThickness(0.025);
        defaultAttributes.setSectionPosition(0.05);

        var title = new cfx.gauge.Title();
        gauge.getTitles().add(title);
        title = new cfx.gauge.Title();
        title.setDock(cfx.gauge.DockArea.Top);
        title.setText("%v");
        title.setFont("40pt Arial");
        title.setTag("TitleLarge");
        title.setResizeableFont(false);
        gauge.getTitles().add(title);
    }
}

lizard.linear = function lizard$linear(gauge, args)
{
    lizard.global(gauge);
    var scale = gauge.getMainScale();
    var bar = scale.getBar();
    var indicator = gauge.getMainIndicator();

    bar.setVisible(true);
    scale.setThickness(0.6);
    scale.setAlignment(cfx.StringAlignment.Near);

    var tickmarks = scale.getTickmarks();
    var major = tickmarks.getMajor();
    major.setSize(0.1);
    major.setStyle(cfx.gauge.TickmarkStyle.Line);
    major.setWidth(0.025);
    major.setPosition(0.875);
    tickmarks.getMedium().setVisible(false);

    bar.setTemplate(gaugeTemplates.lizardLinearBar);

    scale.setAllowHalves(false);

    var styleInfo = lizard.getStyleInfo(args);
 
    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.8);
        scale.setPosition(0);
        indicator.setSize(0.25);
        indicator.setPosition(0.475);
        indicator.setTitle("Current");
        var target = new cfx.gauge.Marker();
        target.setSize(0.4);
        target.setPosition(0.6);
        target.setTitle("Target");
        target.setTemplate("MarkerThinRectangle");
        scale.getIndicators().add(target);

        gauge.getDefaultAttributes().setSectionThickness(bar.getThickness());
        gauge.getDefaultAttributes().setSectionPosition(bar.getPosition());
    }
    else {
        var marker = new cfx.gauge.Marker();
        marker.setSize(0.5);
        gauge.setMainIndicator(marker);
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

lizard.vert = function lizard$vert(gauge, args)
{
    lizard.linear(gauge, args);
    var styleInfo = lizard.getStyleInfo(args);

    if (!styleInfo.isBullet) 
        gauge.getMainIndicator().setTemplate("MarkerTriangle");
}

lizard.horz = function lizard$horz(gauge, args)
{
    lizard.linear(gauge, args);

    var styleInfo = lizard.getStyleInfo(args);

    if (!styleInfo.isBullet) {
        gauge.getMainScale().setThickness(0.5);
        gauge.getMainIndicator().setTemplate("MarkerTriangleInverted");
    }        
}

lizard.chart = function lizard$chart(chart, args)
{
    var gallery = "";

    if (args !== undefined) {
        var t = args[0];
        if (t !== undefined) {
            gallery = t[0];
        }
    }

    chart.getAllSeries().setMarkerSize(4);

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
    chart.getAllSeries().getLine().setWidth(2);

    chart.getAxisY().getGrids().getMajor().setStyle(cfx.DashStyle.Dot);
    chart.getAxisX().getGrids().getMajor().setStyle(cfx.DashStyle.Dot);

    chart.getToolTips().setBorderTemplate('<DataTemplate xmlns:x="a"><DataTemplate.Resources><MultiplyConverter x:Key="multConverter"/></DataTemplate.Resources><Canvas Padding="12"><Border BorderBrush="{Binding Path=ItemFillS}" BorderThickness="2" Background="{Binding Path=Fill}" Opacity="0.85" CornerPercent="0.4" CornerRadius="8" Padding="4,4,4,0"><DockPanel x:Name="container" Orientation="Vertical"><TextBlock Text="{Binding Path=Title}" FontSize="{Binding Path=FontSize, Converter={StaticResource multConverter},ConverterParameter=0.8}" Visible="{Binding Path=TitleVisible}" HorizontalAlignment="Right" FontWeight="Bold" Margin="3,0,3,0"/><Border Height="1" Stroke="{Binding Path=Foreground}" StrokeThickness="1" Margin="0,0,0,4" Visible="{Binding Path=TitleVisible}"/></DockPanel></Border></Canvas></DataTemplate>');
}

lizard.map = function lizard$map(map, args) {
    map.setShowAdditionalLayers(false);
}

lizard.heatmap = function lizard$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#258DC8");
    gradients.getItem(1).setColor("#4EB42E");
}

lizard.equalizer = function lizard$equalizer(equalizer, args) {
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#4EB42E");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F15619");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#33C0C0C0");
}

lizard.trend = function lizard$trend(trend, args)
{
    trend.getSecondaryValues().setAlphaForeground(1);
    trend.getDelta().setVisible(false);
    var secondaryValues = trend.getSecondaryValues();
    secondaryValues.setSeparatorWidth(0);
    var indicator = trend.getIndicator();
    indicator.setStyle(cfx.gauge.IndicatorStyle.TriangleVertical);
    indicator.setPosition(cfx.gauge.IndicatorPosition.Secondary);

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
            trend.getIndicator().setPosition(cfx.gauge.IndicatorPosition.Primary);
        }

        if (trendType.toUpperCase().indexOf("GROUP") >= 0) {
            trend.getBorder().setTemplate("<DataTemplate/>");
        }
    }
}

lizard.border = function lizard$border(border, args)
{
}

})();