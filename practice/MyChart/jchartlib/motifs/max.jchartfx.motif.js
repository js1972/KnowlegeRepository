(function(){

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "jchartfx";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.jchartfxDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                          '<DataTemplate.Resources>' +
                            '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                          '</DataTemplate.Resources>' +
                          '<Grid>' +
                            '<Grid.ColumnDefinitions>' +
                              '<ColumnDefinition Width="6"/>' +
                              '<ColumnDefinition Width="*"/>' +
                              '<ColumnDefinition Width="6"/>' +
                            '</Grid.ColumnDefinitions>' +
                            '<Grid.RowDefinitions>' +
                              '<RowDefinition Height="6"/>' +
                              '<RowDefinition Height="*"/>' +
                             '<RowDefinition Height="12"/>' +
                            '</Grid.RowDefinitions>' +
                             '<Border Grid.Column="1" Grid.Row="1" CornerRadius="27" Background="#000000" BorderBrush="#33000000" Opacity="0.25" StrokeThickness="2">' +
                              '<Border.BitmapEffect>' +
                                '<BlurBitmapEffect Radius="3" OffsetY="2" Merge="true" Source="SourceAlpha"/>' +
                              '</Border.BitmapEffect>' +
                            '</Border>' +
                            '<Border Grid.Column="1" Grid.Row="1" CornerRadius="24" BorderBrush="{x:Null}" Background="{Binding Path=Fill}">' +
                                '<Grid>' +
                                    '<Grid.RowDefinitions>' +
                                        '<RowDefinition Height="Auto"/>' +
                                        '<RowDefinition Height="*"/>' +
                                    '</Grid.RowDefinitions>' +
                                    '<Border Background="{Binding Path=Fill}" CornerRadius="30" CornerPercent="1">' +
                                        '<TextBlock Margin="10" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="11" FontWeight="Normal" />' +
                                    '</Border>' +
                                    '<Border Grid.Row="1" Background="{Binding Path=Fill}" CornerRadius="30" CornerPercent="1">' +
                                        '<Canvas x:Name="targetChart" Margin="8,4,8,12"/>' +
                                    '</Border>' +
                                '</Grid>' +
                            '</Border>' +
                            '<Border Margin="2" Grid.Column="1" Grid.Row="1" CornerRadius="24" BorderBrush="#FFFFFF" StrokeThickness="5"/>' +
                          '<Border Margin="2" Grid.Column="1" Grid.Row="1" CornerRadius="24" BorderBrush="#00000000" StrokeThickness="5">' +
                            '<Border.Fill>' +
                              '<RadialGradientBrush>' +
                                '<RadialGradientBrush.RelativeTransform>' +
                                  '<TransformGroup>' +
                                    '<ScaleTransform CenterX="0.40" CenterY="0.5" ScaleX="4.91" ScaleY="3.11"/>' +
                                    '<TranslateTransform X="0.60" Y="0.54"/>' +
                                  '</TransformGroup>' +
                                '</RadialGradientBrush.RelativeTransform>' +
                                '<GradientStop Color="#CCFFFFFF" Offset="0"/>' +
                                '<GradientStop Color="#00FFFFFF" Offset="0.5276"/>' +
                                '<GradientStop Color="#33000000" Offset="1"/>' +
                              '</RadialGradientBrush>' +
                            '</Border.Fill>' +
                          '</Border>' +
                          '</Grid>' +
            '</DataTemplate>';

    gaugeTemplates.jchartfxRadialDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
          '<Thickness x:Key="borderFactor">0.02</Thickness>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="100" ViewHeight="100"><Canvas>' +
          '<Ellipse Width="100" Height="100" Fill="{Binding Path=Stroke}"/>' +
          '<Ellipse Canvas.Left="1" Canvas.Top="1" Width="98" Height="98" Fill="{Binding Path=Fill}"/>' +
        '</Canvas></Viewbox>' +
      '</DataTemplate>';

    gaugeTemplates.jchartfxRadialIndicator = "RadialIndicatorDefault";

    gaugeTemplates.jchartfxRadialCap = "RadialCapDefault";

    gaugeTemplates.jchartfxRadialGlare = "RadialGlareDefault";

    gaugeTemplates.jchartfxLinearDashBorder = "LinearDashBorderDefault";

    gaugeTemplates.jchartfxLinearBorder = "LinearBorderDefault";

    gaugeTemplates.jchartfxLinearGlare = '<DataTemplate/>';

    gaugeTemplates.jchartfxLinearFiller = "LinearFillerDefault";
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardTitle.fill"] = "0,#0296B1";
    chartTemplates["DashboardTitle.font-family"] = "1,Arial";
    chartTemplates["AxisY_Text.fill"] = "0,#666666";

    chartTemplates.jchartfxBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                          '<DataTemplate.Resources>' +
                            '<Thickness x:Key="externalMargin">16</Thickness>' +
                            '<Thickness x:Key="internalRectMargin">2</Thickness>' +
                            '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                            '<DataTemplate x:Key="internalRect">' +
                              '<Border CornerRadius="6" Background="{Binding Path=Fill}" BorderBrush="{Binding Path=Stroke}" CornerPercent="0.5" />' +
                            '</DataTemplate>' +
                            '<DataTemplate x:Key="internal">' +
                              '<Line Stroke="{Binding Path=Stroke}" X1="{Binding Path=X1}" X2="{Binding Path=X2}" Y1="{Binding Path=Y1}" Y2="{Binding Path=Y2}"/>' +
                            '</DataTemplate>' +
                          '</DataTemplate.Resources>' +
                          '<Grid>' +
                            '<Grid.ColumnDefinitions>' +
                              '<ColumnDefinition Width="6"/>' +
                              '<ColumnDefinition Width="*"/>' +
                              '<ColumnDefinition Width="6"/>' +
                            '</Grid.ColumnDefinitions>' +
                            '<Grid.RowDefinitions>' +
                              '<RowDefinition Height="6"/>' +
                              '<RowDefinition Height="*"/>' +
                             '<RowDefinition Height="12"/>' +
                            '</Grid.RowDefinitions>' +
                             '<Border Grid.Column="1" Grid.Row="1" CornerRadius="27" Background="#000000" BorderBrush="#33000000" Opacity="0.25" StrokeThickness="2">' +
                              '<Border.BitmapEffect>' +
                                '<BlurBitmapEffect Radius="3" OffsetY="2" Merge="true" Source="SourceAlpha"/>' +
                              '</Border.BitmapEffect>' +
                            '</Border>' +
                            '<Border Grid.Column="1" Grid.Row="1" CornerRadius="24" Background="{Binding Path=Fill}" BorderBrush="{x:Null}">' +
                                '<Grid>' +
                                    '<Grid.RowDefinitions>' +
                                        '<RowDefinition Height="Auto"/>' +
                                        '<RowDefinition Height="*"/>' +
                                    '</Grid.RowDefinitions>' +
                                    '<Border Background="{Binding Path=Fill}" CornerRadius="30" CornerPercent="1">' +
                                        '<TextBlock Margin="10,10,10,0" Text="{Binding Path=Title}" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="{Binding Class=DashboardTitle.fill}" FontFamily="{Binding Class=DashboardTitle.font-family}" FontSize="11" FontWeight="Normal" />' +
                                    '</Border>' +
                                    '<Border Grid.Row="1" Background="{Binding Path=Fill}" CornerRadius="30" CornerPercent="1">' +
                                        '<Canvas x:Name="targetChart" Margin="8,0,8,8" />' +
                                    '</Border>' +
                                '</Grid>' +
                            '</Border>' +
                            '<Border Margin="2" Grid.Column="1" Grid.Row="1" CornerRadius="24" BorderBrush="#FFFFFF" StrokeThickness="5"/>' +
                          '<Border Margin="2" Grid.Column="1" Grid.Row="1" CornerRadius="24" BorderBrush="#00000000" StrokeThickness="5">' +
                            '<Border.Fill>' +
                              '<RadialGradientBrush>' +
                                '<RadialGradientBrush.RelativeTransform>' +
                                  '<TransformGroup>' +
                                    '<ScaleTransform CenterX="0.40" CenterY="0.5" ScaleX="4.91" ScaleY="3.11"/>' +
                                    '<TranslateTransform X="0.60" Y="0.54"/>' +
                                  '</TransformGroup>' +
                                '</RadialGradientBrush.RelativeTransform>' +
                                '<GradientStop Color="#CCFFFFFF" Offset="0"/>' +
                                '<GradientStop Color="#00FFFFFF" Offset="0.5276"/>' +
                                '<GradientStop Color="#33000000" Offset="1"/>' +
                              '</RadialGradientBrush>' +
                            '</Border.Fill>' +
                          '</Border>' +
                          '</Grid>' +
            '</DataTemplate>';
}


var jchartfx = function jchartfx()
{
}

cfx.motifs.jchartfx = jchartfx;

jchartfx.getStyleInfo = function jchartfx$global(args)
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
            if (index2 > 0)
            {
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

jchartfx.global = function jchartfx$global(gauge)
{
    gauge.setFont("8pt Arial");
}

jchartfx.radial = function jchartfx$radial(gauge, args)
{
    jchartfx.global(gauge);
 
    var styleInfo = jchartfx.getStyleInfo(args);

    jchartfx.applySections(styleInfo, gauge);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);
}

jchartfx.linear = function jchartfx$linear(gauge, args)
{
    jchartfx.global(gauge);
    var scale = gauge.getMainScale();
    var ticks = scale.getTickmarks();
    var bar = scale.getBar();
    var indicator = gauge.getMainIndicator();

    var styleInfo = jchartfx.getStyleInfo(args);
 
    if (styleInfo.isGroup) {
        gauge.getBorder().setTemplate("<DataTemplate/>");
        gauge.getDashboardBorder().setTemplate("<DataTemplate/>");
    }

    if (styleInfo.isBullet) {
        scale.setThickness(0.9);
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

    jchartfx.applySections(styleInfo, gauge);
}

jchartfx.vert = function jchartfx$vert(gauge, args)
{
    jchartfx.linear(gauge, args);
}

jchartfx.horz = function jchartfx$horz(gauge, args)
{
    jchartfx.linear(gauge, args);
}

jchartfx.applySections = function jchartfx$global(styleInfo, gauge)
{
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

jchartfx.chart = function jchartfx$chart(chart, args)
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

        if (gallery == "GROUP")
        {
            chart.getBorder().setTemplate('<DataTemplate/>');
        }
    }
}

jchartfx.map = function jchartfx$map(map, args) {
    map.setShowAdditionalLayers(false);
}

jchartfx.heatmap = function jchartfx$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#57ACDA");
    gradients.getItem(1).setColor("#93E24E");
}

jchartfx.equalizer = function jchartfx$equalizer(equalizer, args) {
    equalizer.setRoundnessRatio(0);
    var eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F89553");
    eqItem.setCount(2);
    equalizer.getTopItems().add(eqItem);
    eqItem = new cfx.equalizer.EqualizerItem();
    eqItem.setColor("#F5D34A");
    eqItem.setCount(1);
    equalizer.getTopItems().add(eqItem);

    equalizer.setOffColor("#33DBDBD9");
}

jchartfx.trend = function jchartfx$trend(trend, args)
{
    var styleInfo = jchartfx.getStyleInfo(args);

    if (styleInfo.isSingle) {
        trend.getDelta().setVisible(false);
        trend.getPercentChange().setVisible(false);
        trend.getIndicator().setVisible(false);
    }

    if (styleInfo.isGroup) {
        trend.getBorder().setTemplate("<DataTemplate/>");
    }
}

jchartfx.border = function jchartfx$border(border, args)
{
}

})();