(function(){

var cfx = window.cfx;
var sfx = window.sfx;

cfx.motif = "topbar";

var gaugeTemplates = sfx["gauge.templates"];

if (gaugeTemplates != undefined) {
    gaugeTemplates.topbarDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
                      '<DataTemplate.Resources>' +
                        '<sys:String x:Key="plotMargin">targetChart</sys:String>' +
                      '</DataTemplate.Resources>' +
                      '<Canvas>' +
                        '<Border Background="#000000" Opacity="0.25" Canvas.Left="8" Canvas.Top="8">' +
                           '<Border.BitmapEffect>' +
                             '<BlurBitmapEffect Radius="1" />' +
                            '</Border.BitmapEffect>' +
                        '</Border>' +
                        '<Grid Margin="3,3,4,4">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<Border Background="{Binding Class=DashboardCaption.fill}" Stroke="{x:Null}">' +
                            '<TextBlock Margin="8,0" Text="{Binding Path=Title}" FontSize="11" FontFamily="{Binding Class=DashboardTitle.font-family}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardCaption.stroke}"/>' +
                          '</Border>' +
                          '<Border Grid.Row="1" Background="{Binding Path=Fill}">' +
                          '<Canvas x:Name="targetChart" Margin="4,12,4,10"/>' +
                          '</Border>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';

    gaugeTemplates.topbarRadialDashBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
        '<DataTemplate.Resources>' +
          '<Thickness x:Key="borderFactor">0.03</Thickness>' +
        '</DataTemplate.Resources>' +
        '<Viewbox ViewWidth="100" ViewHeight="100"><Canvas>' +
          '<Ellipse Width="100" Height="100" Fill="{Binding Path=Stroke}"/>' +
          '<Ellipse Canvas.Left="3" Canvas.Top="3" Width="94" Height="94" Fill="{Binding Path=Fill}"/>' +
        '</Canvas></Viewbox>' +
      '</DataTemplate>';

    gaugeTemplates.topbarRadialIndicator = "RadialIndicatorDefault";

    gaugeTemplates.topbarRadialCap = "RadialCapDefault";

    gaugeTemplates.topbarRadialGlare = '<DataTemplate/>';

    gaugeTemplates.topbarLinearDashBorder = '<DataTemplate/>';

    gaugeTemplates.topbarLinearGlare = '<DataTemplate/>';

    gaugeTemplates.topbarLinearFiller = "LinearFillerDefault";
}


var chartTemplates = sfx["vector.templates"];

if (chartTemplates != undefined) {
    chartTemplates["DashboardCaption.fill"] = "0,#57ACDA";
    chartTemplates["DashboardCaption.stroke"] = "0,#FFFFFF";
    chartTemplates["DashboardTitle.font-family"] = "1,Arial";
    chartTemplates["AxisY_Text.fill"] = "0,#666666";

    chartTemplates.topbarBorder = '<DataTemplate xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:sys="clr-namespace:System;assembly=mscorlib">' +
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
                        '<Border Background="#000000" Opacity="0.25" Canvas.Left="8" Canvas.Top="8">' +
                           '<Border.BitmapEffect>' +
                             '<BlurBitmapEffect Radius="1"/>' +
                            '</Border.BitmapEffect>' +
                        '</Border>' +
                        '<Grid Margin="3">' +
                          '<Grid.RowDefinitions>' +
                            '<RowDefinition Height="Auto" MinHeight="32"/>' +
                            '<RowDefinition Height="*"/>' +
                          '</Grid.RowDefinitions>' +
                          '<Border Background="{Binding Class=DashboardCaption.fill}" Stroke="{x:Null}">' +
                            '<TextBlock Margin="8,0" Text="{Binding Path=Title}" FontSize="11" FontFamily="{Binding Class=DashboardTitle.font-family}" VerticalAlignment="Center" HorizontalAlignment="Left" Foreground="{Binding Class=DashboardCaption.stroke}"/>' +
                          '</Border>' +
                          '<Border Grid.Row="1" Background="{Binding Path=Fill}">' +
                          '<Canvas x:Name="targetChart" Margin="0,6,0,6"/>' +
                          '</Border>' +
                        '</Grid>' +
                      '</Canvas>' +
                '</DataTemplate>';
}


var topbar = function topbar()
{
}

cfx.motifs.topbar = topbar;

topbar.getStyleInfo = function topbar$global(args)
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

topbar.global = function topbar$global(gauge)
{
    gauge.setFont("8pt Arial");
}

topbar.radial = function topbar$radial(gauge, args)
{
    topbar.global(gauge);
 
    var styleInfo = topbar.getStyleInfo(args);
 
    if (styleInfo.name != null)
        gauge.setStyle(styleInfo.name);
}

topbar.linear = function topbar$linear(gauge, args)
{
    topbar.global(gauge);

    var scale = gauge.getMainScale();
    var bar = scale.getBar();
    var indicator = scale.getMainIndicator();

    var styleInfo = topbar.getStyleInfo(args);
 
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

topbar.vert = function topbar$vert(gauge, args)
{
    topbar.linear(gauge, args);
}

topbar.horz = function topbar$horz(gauge, args)
{
    topbar.linear(gauge, args);

}

topbar.chart = function topbar$chart(chart, args)
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
}

topbar.heatmap = function topbar$heatmap(heatmap, args) {
    var gradients = heatmap.getGradientStops();
    gradients.getItem(0).setColor("#57ACDA");
    gradients.getItem(1).setColor("#93E24E");
}

topbar.equalizer = function topbar$equalizer(equalizer, args) {
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

topbar.trend = function topbar$trend(trend, args)
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
}

topbar.map = function topbar$map(map, args) {
    map.setShowAdditionalLayers(false);
}

topbar.border = function topbar$border(border, args)
{
}

})();