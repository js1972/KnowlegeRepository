$(document).ready(function(){
$("#container_SideBySideBars").data("function",SideBySideBars);
	$("#container_SideBySideBars").data("title","Side-by-side Bars");
	if ($("#container_SideBySideBars").parent().attr("thumb_type") != "none") {	
		var chart_SideBySideBars = new cfx.Chart();
		SideBySideBars(chart_SideBySideBars);		
		chart_SideBySideBars.create(document.getElementById("container_SideBySideBars"));
		if ($("#container_SideBySideBars").parent().attr("thumb_type") == "crop") {
			Positioning(chart_SideBySideBars,"","",$("#container_SideBySideBars"),"chart_container");
		}
		else {
			fix_thumb(chart_SideBySideBars, "chart");	
		}	
	}
	
	$("#container_GanttBars").data("function",GanttBars);
	$("#container_GanttBars").data("title","Gantt Bars");
	if ($("#container_GanttBars").parent().attr("thumb_type") != "none") {	
		var chart_GanttBars = new cfx.Chart();
		GanttBars(chart_GanttBars);		
		chart_GanttBars.create(document.getElementById("container_GanttBars"));
		if ($("#container_GanttBars").parent().attr("thumb_type") == "crop") {
			Positioning(chart_GanttBars,"","",$("#container_GanttBars"),"chart_container");
		}
		else {
			fix_thumb(chart_GanttBars, "chart");	
		}	
	}
	
	$("#container_BarWithNegativeValues").data("function",BarWithNegativeValues);
	$("#container_BarWithNegativeValues").data("title","Bar with Negative Values");
	if ($("#container_BarWithNegativeValues").parent().attr("thumb_type") != "none") {	
		var chart_BarWithNegativeValues = new cfx.Chart();
		BarWithNegativeValues(chart_BarWithNegativeValues);		
		chart_BarWithNegativeValues.create(document.getElementById("container_BarWithNegativeValues"));
		if ($("#container_BarWithNegativeValues").parent().attr("thumb_type") == "crop") {
			Positioning(chart_BarWithNegativeValues,"","",$("#container_BarWithNegativeValues"),"chart_container");
		}
		else {
			fix_thumb(chart_BarWithNegativeValues, "chart");	
		}	
	}
	
	$("#container_GanttWithNegativeValues").data("function",GanttWithNegativeValues);
	$("#container_GanttWithNegativeValues").data("title","Gantt with Negative Values");
	if ($("#container_GanttWithNegativeValues").parent().attr("thumb_type") != "none") {	
		var chart_GanttWithNegativeValues = new cfx.Chart();
		GanttWithNegativeValues(chart_GanttWithNegativeValues);		
		chart_GanttWithNegativeValues.create(document.getElementById("container_GanttWithNegativeValues"));
		if ($("#container_GanttWithNegativeValues").parent().attr("thumb_type") == "crop") {
			Positioning(chart_GanttWithNegativeValues,"","",$("#container_GanttWithNegativeValues"),"chart_container");
		}
		else {
			fix_thumb(chart_GanttWithNegativeValues, "chart");	
		}	
	}
	
	$("#container_BarSeparation").data("function",BarSeparation);
	$("#container_BarSeparation").data("title","Bar Separation");
	if ($("#container_BarSeparation").parent().attr("thumb_type") != "none") {	
		var chart_BarSeparation = new cfx.Chart();
		BarSeparation(chart_BarSeparation);		
		chart_BarSeparation.create(document.getElementById("container_BarSeparation"));
		if ($("#container_BarSeparation").parent().attr("thumb_type") == "crop") {
			Positioning(chart_BarSeparation,"undefined","undefined",$("#container_BarSeparation"),"chart_container");
		}
		else {
			fix_thumb(chart_BarSeparation, "chart");	
		}	
	}
	
	$("#container_OverlappingBars").data("function",OverlappingBars);
	$("#container_OverlappingBars").data("title","Overlapping Bars");
	if ($("#container_OverlappingBars").parent().attr("thumb_type") != "none") {	
		var chart_OverlappingBars = new cfx.Chart();
		OverlappingBars(chart_OverlappingBars);		
		chart_OverlappingBars.create(document.getElementById("container_OverlappingBars"));
		if ($("#container_OverlappingBars").parent().attr("thumb_type") == "crop") {
			Positioning(chart_OverlappingBars,"undefined","undefined",$("#container_OverlappingBars"),"chart_container");
		}
		else {
			fix_thumb(chart_OverlappingBars, "chart");	
		}	
	}
	
	$("#container_BarStacked").data("function",BarStacked);
	$("#container_BarStacked").data("title","Bar Stacked");
	if ($("#container_BarStacked").parent().attr("thumb_type") != "none") {	
		var chart_BarStacked = new cfx.Chart();
		BarStacked(chart_BarStacked);		
		chart_BarStacked.create(document.getElementById("container_BarStacked"));
		if ($("#container_BarStacked").parent().attr("thumb_type") == "crop") {
			Positioning(chart_BarStacked,"","",$("#container_BarStacked"),"chart_container");
		}
		else {
			fix_thumb(chart_BarStacked, "chart");	
		}	
	}
	
	$("#container_GanttStacked").data("function",GanttStacked);
	$("#container_GanttStacked").data("title","Gantt Stacked");
	if ($("#container_GanttStacked").parent().attr("thumb_type") != "none") {	
		var chart_GanttStacked = new cfx.Chart();
		GanttStacked(chart_GanttStacked);		
		chart_GanttStacked.create(document.getElementById("container_GanttStacked"));
		if ($("#container_GanttStacked").parent().attr("thumb_type") == "crop") {
			Positioning(chart_GanttStacked,"","",$("#container_GanttStacked"),"chart_container");
		}
		else {
			fix_thumb(chart_GanttStacked, "chart");	
		}	
	}
	
	$("#container_BarStacked100Percent").data("function",BarStacked100Percent);
	$("#container_BarStacked100Percent").data("title","Bar Stacked 100 Percent");
	if ($("#container_BarStacked100Percent").parent().attr("thumb_type") != "none") {	
		var chart_BarStacked100Percent = new cfx.Chart();
		BarStacked100Percent(chart_BarStacked100Percent);		
		chart_BarStacked100Percent.create(document.getElementById("container_BarStacked100Percent"));
		if ($("#container_BarStacked100Percent").parent().attr("thumb_type") == "crop") {
			Positioning(chart_BarStacked100Percent,"","",$("#container_BarStacked100Percent"),"chart_container");
		}
		else {
			fix_thumb(chart_BarStacked100Percent, "chart");	
		}	
	}
	
	$("#container_InitialValues").data("function",InitialValues);
	$("#container_InitialValues").data("title","Initial Values");
	if ($("#container_InitialValues").parent().attr("thumb_type") != "none") {	
		var chart_InitialValues = new cfx.Chart();
		InitialValues(chart_InitialValues);		
		chart_InitialValues.create(document.getElementById("container_InitialValues"));
		if ($("#container_InitialValues").parent().attr("thumb_type") == "crop") {
			Positioning(chart_InitialValues,"","",$("#container_InitialValues"),"chart_container");
		}
		else {
			fix_thumb(chart_InitialValues, "chart");	
		}	
	}
	
	$("#container_Bar3DStacked").data("function",Bar3DStacked);
	$("#container_Bar3DStacked").data("title","Bar 3D Stacked");
	if ($("#container_Bar3DStacked").parent().attr("thumb_type") != "none") {	
		var chart_Bar3DStacked = new cfx.Chart();
		Bar3DStacked(chart_Bar3DStacked);		
		chart_Bar3DStacked.create(document.getElementById("container_Bar3DStacked"));
		if ($("#container_Bar3DStacked").parent().attr("thumb_type") == "crop") {
			Positioning(chart_Bar3DStacked,"","",$("#container_Bar3DStacked"),"chart_container");
		}
		else {
			fix_thumb(chart_Bar3DStacked, "chart");	
		}	
	}
	
	$("#container_Bar3DOblique").data("function",Bar3DOblique);
	$("#container_Bar3DOblique").data("title","Bar 3D Oblique");
	if ($("#container_Bar3DOblique").parent().attr("thumb_type") != "none") {	
		var chart_Bar3DOblique = new cfx.Chart();
		Bar3DOblique(chart_Bar3DOblique);		
		chart_Bar3DOblique.create(document.getElementById("container_Bar3DOblique"));
		if ($("#container_Bar3DOblique").parent().attr("thumb_type") == "crop") {
			Positioning(chart_Bar3DOblique,"","",$("#container_Bar3DOblique"),"chart_container");
		}
		else {
			fix_thumb(chart_Bar3DOblique, "chart");	
		}	
	}
	
	$("#container_Cylinder3DClustered").data("function",Cylinder3DClustered);
	$("#container_Cylinder3DClustered").data("title","Cylinder 3D Clustered");
	if ($("#container_Cylinder3DClustered").parent().attr("thumb_type") != "none") {	
		var chart_Cylinder3DClustered = new cfx.Chart();
		Cylinder3DClustered(chart_Cylinder3DClustered);		
		chart_Cylinder3DClustered.create(document.getElementById("container_Cylinder3DClustered"));
		if ($("#container_Cylinder3DClustered").parent().attr("thumb_type") == "crop") {
			Positioning(chart_Cylinder3DClustered,"","",$("#container_Cylinder3DClustered"),"chart_container");
		}
		else {
			fix_thumb(chart_Cylinder3DClustered, "chart");	
		}	
	}
	
	$("#container_Cylinder3DAngled").data("function",Cylinder3DAngled);
	$("#container_Cylinder3DAngled").data("title","Cylinder 3D Angled");
	if ($("#container_Cylinder3DAngled").parent().attr("thumb_type") != "none") {	
		var chart_Cylinder3DAngled = new cfx.Chart();
		Cylinder3DAngled(chart_Cylinder3DAngled);		
		chart_Cylinder3DAngled.create(document.getElementById("container_Cylinder3DAngled"));
		if ($("#container_Cylinder3DAngled").parent().attr("thumb_type") == "crop") {
			Positioning(chart_Cylinder3DAngled,"","",$("#container_Cylinder3DAngled"),"chart_container");
		}
		else {
			fix_thumb(chart_Cylinder3DAngled, "chart");	
		}	
	}
	
	$("#container_StackedCylinder").data("function",StackedCylinder);
	$("#container_StackedCylinder").data("title","Stacked Cylinder");
	if ($("#container_StackedCylinder").parent().attr("thumb_type") != "none") {	
		var chart_StackedCylinder = new cfx.Chart();
		StackedCylinder(chart_StackedCylinder);		
		chart_StackedCylinder.create(document.getElementById("container_StackedCylinder"));
		if ($("#container_StackedCylinder").parent().attr("thumb_type") == "crop") {
			Positioning(chart_StackedCylinder,"undefined","undefined",$("#container_StackedCylinder"),"chart_container");
		}
		else {
			fix_thumb(chart_StackedCylinder, "chart");	
		}	
	}
	
	$("#container_Cube").data("function",Cube);
	$("#container_Cube").data("title","Cube");
	if ($("#container_Cube").parent().attr("thumb_type") != "none") {	
		var chart_Cube = new cfx.Chart();
		Cube(chart_Cube);		
		chart_Cube.create(document.getElementById("container_Cube"));
		if ($("#container_Cube").parent().attr("thumb_type") == "crop") {
			Positioning(chart_Cube,"","",$("#container_Cube"),"chart_container");
		}
		else {
			fix_thumb(chart_Cube, "chart");	
		}	
	}	
});

function SideBySideBars(chart1)
{
	chart1.setGallery(cfx.Gallery.Bar);
PopulateCarProduction(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Vehicles Production by Month");
titles.add(title);
}
function GanttBars(chart1)
{
	chart1.setGallery(cfx.Gallery.Gantt);
PopulateProductSales(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Wine Sales by Type");
titles.add(title);
chart1.getAxisY().getLabelsFormat().setFormat(cfx.AxisFormat.Currency);
}
function BarWithNegativeValues(chart1)
{
	chart1.setGallery(cfx.Gallery.Bar);
PopulateBirthVariation(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Birth Variation by Gender");
titles.add(title);
chart1.getAxisY().getTitle().setText("Variation (%)");
}
function GanttWithNegativeValues(chart1)
{
	chart1.setGallery(cfx.Gallery.Gantt);
PopulateBirthVariation(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Birth Variation by Gender");
titles.add(title);
chart1.getAxisY().getTitle().setText("Variation (%)");
}
function BarSeparation(chart1)
{
	// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setVolume(100);
var bar;
bar = chart1.getGalleryAttributes();
bar.setIntraSeriesGap(0);
// END RELEVANT CODE
PopulateCarProduction(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Vehicles Production by Month");
titles.add(title);
}
function OverlappingBars(chart1)
{
	PopulateProductSales(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Wine Sales by Type");
titles.add(title);
chart1.getAxisY().getLabelsFormat().setFormat(cfx.AxisFormat.Currency);
// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
var bar = chart1.getGalleryAttributes();
bar.setOverlap(true);
chart1.getSeries().getItem(0).setVolume(20);
chart1.getSeries().getItem(1).setVolume(50);
chart1.getSeries().getItem(2).setVolume(80);
// END RELEVANT CODE
}
function BarStacked(chart1)
{
	// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setStacked(cfx.Stacked.Normal);
// END RELEVANT CODE
PopulateProductSales(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Wine Sales by Type");
titles.add(title);
chart1.getAxisY().getLabelsFormat().setFormat(cfx.AxisFormat.Currency);
}
function GanttStacked(chart1)
{
	PopulateCarProduction(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Vehicles Production by Month - SUV vs. Others");
titles.add(title);
// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Gantt);
chart1.getAllSeries().setStacked(cfx.Stacked.Normal);
chart1.getSeries().getItem(2).setStacked(false);
// END RELEVANT CODE
}
function BarStacked100Percent(chart1)
{
	// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setStackedStyle(cfx.Stacked.Stacked100);
// END RELEVANT CODE
PopulatePopulationData(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Population Distribution by Gender and Age Range");
titles.add(title);
chart1.getAxisY().getTitle().setText("Percentage");
chart1.getAxisX().getTitle().setText("Age Range");
chart1.getLegendBox().setDock(cfx.DockArea.Bottom);
}
function InitialValues(chart1)
{
	// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
var fields = chart1.getDataSourceSettings().getFields();
var fieldLow = new cfx.FieldMap();
fieldLow.setName("Low");
fieldLow.setUsage(cfx.FieldUsage.FromValue);
fields.add(fieldLow);
var fieldHigh = new cfx.FieldMap();
fieldHigh.setName("High");
fieldHigh.setUsage(cfx.FieldUsage.Value);
fields.add(fieldHigh);
// END RELEVANT CODE
var MonthField = new cfx.FieldMap();
MonthField.setName("Month");
MonthField.setUsage(cfx.FieldUsage.Label);
fields.add(MonthField);
PopulateMiamiClimate(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Miami Temperature Range in 2012");
titles.add(title);
chart1.getAxisY().getTitle().setText("Temperature (°F)");
chart1.getLegendBox().setVisible(false);
}
function Bar3DStacked(chart1)
{
	// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setStacked(cfx.Stacked.Normal);
chart1.getView3D().setEnabled(true);
// END RELEVANT CODE
PopulateCarProduction(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Vehicles Production by Month");
titles.add(title);
chart1.getAxisY().getTitle().setText("Number of Vehicles");
}
function Bar3DOblique(chart1)
{
	PopulateProductSales(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Wine Sales by Type");
titles.add(title);
chart1.getAxisY().getLabelsFormat().setFormat(cfx.AxisFormat.Currency);
// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getView3D().setEnabled(true);
chart1.getView3D().setAngleX(45);
chart1.getView3D().setCluster(true);
// END RELEVANT CODE
}
function Cylinder3DClustered(chart1)
{
	PopulateMiamiClimate_Precipitation_WindSpeed_RelativeHumidity(chart1);
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setBarShape(cfx.BarShape.Cylinder);
chart1.getView3D().setEnabled(true);
chart1.getView3D().setCluster(true);
chart1.getLegendBox().setVisible(false);
chart1.getPlotAreaMargin().setRight(80);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Miami Climate Features by Month in 2012");
titles.add(title);
var series = chart1.getSeries();
series.getItem(0).setText = "Precipitation";
series.getItem(1).setText = "Wind Speed";
series.getItem(2).setText = "Relative Humidity";
}
function Cylinder3DAngled(chart1)
{
	PopulateMiamiClimate_Precipitation_WindSpeed_RelativeHumidity(chart1);
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setBarShape(cfx.BarShape.Cylinder);
chart1.getView3D().setEnabled(true);
chart1.getView3D().setCluster(true);
chart1.getView3D().setAngleX(30);
chart1.getView3D().setAngleY(30);
chart1.getLegendBox().setVisible(false);
chart1.getPlotAreaMargin().setRight(80);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Miami Climate Features by Month in 2012");
titles.add(title);
var series = chart1.getSeries();
series.getItem(0).setText = "Precipitation";
series.getItem(1).setText = "Wind Speed";
series.getItem(2).setText = "Relative Humidity";
}
function StackedCylinder(chart1)
{
	PopulateNewConstructions(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("New Constructions in US Market");
titles.add(title);
chart1.getLegendBox().setDock(cfx.DockArea.Bottom);
chart1.getAxisX().setStep(30);
// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Bar);
chart1.getAllSeries().setBarShape(cfx.BarShape.Cylinder);
chart1.getAllSeries().setStacked(cfx.Stacked.Normal);
// END RELEVANT CODE
}
function Cube(chart1)
{
	PopulateMiamiClimate_Precipitation(chart1);
var titles = chart1.getTitles();
var title = new cfx.TitleDockable();
title.setText("Miami Precipitation by Month in 2012");
titles.add(title);
chart1.getAxisY().getTitle().setText("inches");
// RELEVANT CODE
chart1.setGallery(cfx.Gallery.Cube);
// END RELEVANT CODE
chart1.getLegendBox().setVisible(false);
}

function PopulateCarProduction(chart1) {
        var items = [{
            "Sedan": 1760,
            "Coupe": 535,
            "SUV": 695,
            "Month": "Jan"
        }, {
            "Sedan": 1849,
            "Coupe": 395,
            "SUV": 688,
            "Month": "Feb"
        }, {
            "Sedan": 2831,
            "Coupe": 685,
            "SUV": 1047,
            "Month": "Mar"
        }, {
            "Sedan": 2851,
            "Coupe": 984,
            "SUV": 1652,
            "Month": "Apr"
        }, {
            "Sedan": 2961,
            "Coupe": 1579,
            "SUV": 1889,
            "Month": "May"
        }, {
            "Sedan": 1519,
            "Coupe": 1539,
            "SUV": 1766,
            "Month": "Jun"
        }, {
            "Sedan": 2633,
            "Coupe": 1489,
            "SUV": 1361,
            "Month": "Jul"
        }, {
            "Sedan": 1140,
            "Coupe": 650,
            "SUV": 874,
            "Month": "Aug"
        }, {
            "Sedan": 1626,
            "Coupe": 653,
            "SUV": 693,
            "Month": "Sep"
        }, {
            "Sedan": 1478,
            "Coupe": 2236,
            "SUV": 786,
            "Month": "Oct"
        }, {
            "Sedan": 1306,
            "Coupe": 1937,
            "SUV": 599,
            "Month": "Nov"
        }, {
            "Sedan": 1607,
            "Coupe": 2138,
            "SUV": 678,
            "Month": "Dec"
        }];
    
    
        chart1.setDataSource(items);
    }
    function PopulateProductSales(chart1) {
        var items = [{
            "Month": "Jan",
            "White": 12560,
            "Red": 23400,
            "Sparkling": 34500
        }, {
            "Month": "Feb",
            "White": 13400,
            "Red": 21000,
            "Sparkling": 38900
        }, {
            "Month": "Mar",
            "White": 16700,
            "Red": 17000,
            "Sparkling": 42100
        }, {
            "Month": "Apr",
            "White": 12000,
            "Red": 19020,
            "Sparkling": 43800
        }, {
            "Month": "May",
            "White": 15800,
            "Red": 26500,
            "Sparkling": 37540
        }, {
            "Month": "Jun",
            "White": 9800,
            "Red": 27800,
            "Sparkling": 32580
        }, {
            "Month": "Jul",
            "White": 17800,
            "Red": 29820,
            "Sparkling": 34000
        }, {
            "Month": "Aug",
            "White": 19800,
            "Red": 17800,
            "Sparkling": 38000
        }, {
            "Month": "Sep",
            "White": 23200,
            "Red": 32000,
            "Sparkling": 41300
        }, {
            "Month": "Oct",
            "White": 16700,
            "Red": 26500,
            "Sparkling": 46590
        }, {
            "Month": "Nov",
            "White": 11800,
            "Red": 23000,
            "Sparkling": 48700
        }, {
            "Month": "Dec",
            "White": 13400,
            "Red": 15400,
            "Sparkling": 49100
        }];
    
        chart1.setDataSource(items);
    }
    function PopulateBirthVariation(chart1) {
        var items = [{
            "Year": "2007",
            "Male": 4.5,
            "Female": 4.9
        }, {
            "Year": "2008",
            "Male": -1.8,
            "Female": 1.2
        }, {
            "Year": "2009",
            "Male": 2.3,
            "Female": -2.6
        }, {
            "Year": "2010",
            "Male": 2,
            "Female": 3
        }, {
            "Year": "2011",
            "Male": -0.5,
            "Female": -1.7
        }, {
            "Year": "2012",
            "Male": 3.1,
            "Female": -0.9
        }];
    
        chart1.setDataSource(items);
    }
    function PopulatePopulationData(chart1) {
        var items = [{
            "Range": "0-4",
            "Male": 10471,
            "Female": 10024
        }, {
            "Range": "5-9",
            "Male": 9954,
            "Female": 9512
        }, {
            "Range": "10-14",
            "Male": 10670,
            "Female": 10167
        }, {
            "Range": "15-19",
            "Male": 10871,
            "Female": 10312
        }, {
            "Range": "20-24",
            "Male": 10719,
            "Female": 10178
        }, {
            "Range": "25-29",
            "Male": 10060,
            "Female": 9744
        }, {
            "Range": "30-34",
            "Male": 10021,
            "Female": 9864
        }, {
            "Range": "35-39",
            "Male": 10479,
            "Female": 10424
        }, {
            "Range": "40-44",
            "Male": 11294,
            "Female": 11454
        }, {
            "Range": "45-49",
            "Male": 11080,
            "Female": 11377
        }, {
            "Range": "50-54",
            "Male": 9772,
            "Female": 10212
        }, {
            "Range": "55-59",
            "Male": 8415,
            "Female": 8944
        }, {
            "Range": "60-64",
            "Male": 6203,
            "Female": 6814
        }, {
            "Range": "65-69",
            "Male": 4712,
            "Female": 5412
        }, {
            "Range": "70-74",
            "Male": 3804,
            "Female": 4697
        }, {
            "Range": "75-79",
            "Male": 3094,
            "Female": 4282
        }, {
            "Range": "80-84",
            "Male": 2117,
            "Female": 3459
        }, {
            "Range": "85-89",
            "Male": 1072,
            "Female": 2135
        }, {
            "Range": "90-94",
            "Male": 397,
            "Female": 1034
        }, {
            "Range": "95-99",
            "Male": 91,
            "Female": 321
        }, {
            "Range": "100+",
            "Male": 12,
            "Female": 58
        }];
    
    
        chart1.setDataSource(items);
    }
    function PopulateMiamiClimate(chart1) {
        var items = [{
            "Month": "Jan",
            "Low": 59.6,
            "High": 76.5,
            "Average": 67.2,
            "Precipitation": 1.88,
            "WindSpeed": 9.5,
            "RelativeHumidity": 59
        }, {
            "Month": "Feb",
            "Low": 60.5,
            "High": 77.7,
            "Average": 68.5,
            "Precipitation": 2.07,
            "WindSpeed": 10.1,
            "RelativeHumidity": 71
        }, {
            "Month": "Mar",
            "Low": 64,
            "High": 80.7,
            "Average": 71.7,
            "Precipitation": 2.56,
            "WindSpeed": 10.5,
            "RelativeHumidity": 69.5
        }, {
            "Month": "Apr",
            "Low": 67.6,
            "High": 83.8,
            "Average": 75.2,
            "Precipitation": 3.36,
            "WindSpeed": 10.5,
            "RelativeHumidity": 67.5
        }, {
            "Month": "May",
            "Low": 72,
            "High": 87.2,
            "Average": 78.7,
            "Precipitation": 5.52,
            "WindSpeed": 9.5,
            "RelativeHumidity": 67
        }, {
            "Month": "Jun",
            "Low": 75.2,
            "High": 89.5,
            "Average": 81.4,
            "Precipitation": 8.54,
            "WindSpeed": 8.3,
            "RelativeHumidity": 71
        }, {
            "Month": "Jul",
            "Low": 76.5,
            "High": 90.9,
            "Average": 82.6,
            "Precipitation": 5.79,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Aug",
            "Low": 76.5,
            "High": 90.6,
            "Average": 82.8,
            "Precipitation": 8.63,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Sep",
            "Low": 75.7,
            "High": 89,
            "Average": 81.9,
            "Precipitation": 8.38,
            "WindSpeed": 8.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Oct",
            "Low": 72.2,
            "High": 85.4,
            "Average": 78.3,
            "Precipitation": 6.19,
            "WindSpeed": 9.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Nov",
            "Low": 67.5,
            "High": 81.2,
            "Average": 73.6,
            "Precipitation": 3.43,
            "WindSpeed": 9.7,
            "RelativeHumidity": 74
        }, {
            "Month": "Dec",
            "Low": 62.2,
            "High": 77.5,
            "Average": 69.1,
            "Precipitation": 2.18,
            "WindSpeed": 9.2,
            "RelativeHumidity": 73
        }];
    
    
        chart1.setDataSource(items);
    }
    function PopulateMiamiClimate_Precipitation_WindSpeed_RelativeHumidity(chart1) {
        var items = [{
            "Month": "Jan",
            "Low": 59.6,
            "High": 76.5,
            "Average": 67.2,
            "Precipitation": 1.88,
            "WindSpeed": 9.5,
            "RelativeHumidity": 59
        }, {
            "Month": "Feb",
            "Low": 60.5,
            "High": 77.7,
            "Average": 68.5,
            "Precipitation": 2.07,
            "WindSpeed": 10.1,
            "RelativeHumidity": 71
        }, {
            "Month": "Mar",
            "Low": 64,
            "High": 80.7,
            "Average": 71.7,
            "Precipitation": 2.56,
            "WindSpeed": 10.5,
            "RelativeHumidity": 69.5
        }, {
            "Month": "Apr",
            "Low": 67.6,
            "High": 83.8,
            "Average": 75.2,
            "Precipitation": 3.36,
            "WindSpeed": 10.5,
            "RelativeHumidity": 67.5
        }, {
            "Month": "May",
            "Low": 72,
            "High": 87.2,
            "Average": 78.7,
            "Precipitation": 5.52,
            "WindSpeed": 9.5,
            "RelativeHumidity": 67
        }, {
            "Month": "Jun",
            "Low": 75.2,
            "High": 89.5,
            "Average": 81.4,
            "Precipitation": 8.54,
            "WindSpeed": 8.3,
            "RelativeHumidity": 71
        }, {
            "Month": "Jul",
            "Low": 76.5,
            "High": 90.9,
            "Average": 82.6,
            "Precipitation": 5.79,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Aug",
            "Low": 76.5,
            "High": 90.6,
            "Average": 82.8,
            "Precipitation": 8.63,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Sep",
            "Low": 75.7,
            "High": 89,
            "Average": 81.9,
            "Precipitation": 8.38,
            "WindSpeed": 8.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Oct",
            "Low": 72.2,
            "High": 85.4,
            "Average": 78.3,
            "Precipitation": 6.19,
            "WindSpeed": 9.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Nov",
            "Low": 67.5,
            "High": 81.2,
            "Average": 73.6,
            "Precipitation": 3.43,
            "WindSpeed": 9.7,
            "RelativeHumidity": 74
        }, {
            "Month": "Dec",
            "Low": 62.2,
            "High": 77.5,
            "Average": 69.1,
            "Precipitation": 2.18,
            "WindSpeed": 9.2,
            "RelativeHumidity": 73
        }];
        // Since not all the fields in the DataSource are required, we must perform the corresponding bindings
        var fields = chart1.getDataSourceSettings().getFields();
        var fieldPrecipitation = new cfx.FieldMap();
        fieldPrecipitation.setName("Precipitation");
        fieldPrecipitation.setUsage(cfx.FieldUsage.Value);
        fields.add(fieldPrecipitation);var fieldWindSpeed = new cfx.FieldMap();
        fieldWindSpeed.setName("WindSpeed");
        fieldWindSpeed.setUsage(cfx.FieldUsage.Value);
        fields.add(fieldWindSpeed);var fieldRelativeHumidity = new cfx.FieldMap();
        fieldRelativeHumidity.setName("RelativeHumidity");
        fieldRelativeHumidity.setUsage(cfx.FieldUsage.Value);
        fields.add(fieldRelativeHumidity);
        var MonthField = new cfx.FieldMap();
        MonthField.setName("Month");
        MonthField.setUsage(cfx.FieldUsage.Label);
        fields.add(MonthField);
    
        chart1.setDataSource(items);
    }
    function PopulateNewConstructions(chart1) {
        var items = [{
            "Date": "2012-07-01T00:00:00.000Z",
            "Northeast": 88,
            "Midwest": 116,
            "South": 351,
            "West": 186
        }, {
            "Date": "2012-08-01T00:00:00.000Z",
            "Northeast": 75,
            "Midwest": 128,
            "South": 376,
            "West": 170
        }, {
            "Date": "2012-09-01T00:00:00.000Z",
            "Northeast": 79,
            "Midwest": 147,
            "South": 424,
            "West": 204
        }, {
            "Date": "2012-10-01T00:00:00.000Z",
            "Northeast": 75,
            "Midwest": 151,
            "South": 425,
            "West": 213
        }, {
            "Date": "2012-11-01T00:00:00.000Z",
            "Northeast": 68,
            "Midwest": 154,
            "South": 449,
            "West": 171
        }, {
            "Date": "2012-12-01T00:00:00.000Z",
            "Northeast": 115,
            "Midwest": 190,
            "South": 465,
            "West": 213
        }, {
            "Date": "2013-01-01T00:00:00.000Z",
            "Northeast": 87,
            "Midwest": 95,
            "South": 483,
            "West": 233
        }, {
            "Date": "2013-02-01T00:00:00.000Z",
            "Northeast": 106,
            "Midwest": 135,
            "South": 505,
            "West": 223
        }, {
            "Date": "2013-03-01T00:00:00.000Z",
            "Northeast": 94,
            "Midwest": 140,
            "South": 554,
            "West": 217
        }, {
            "Date": "2013-04-01T00:00:00.000Z",
            "Northeast": 79,
            "Midwest": 154,
            "South": 412,
            "West": 207
        }, {
            "Date": "2013-05-01T00:00:00.000Z",
            "Northeast": 101,
            "Midwest": 135,
            "South": 482,
            "West": 201
        }, {
            "Date": "2013-06-01T00:00:00.000Z",
            "Northeast": 82,
            "Midwest": 126,
            "South": 431,
            "West": 207
        }];
    
        chart1.setDataSource(items);
    }
    function PopulateMiamiClimate_Precipitation(chart1) {
        var items = [{
            "Month": "Jan",
            "Low": 59.6,
            "High": 76.5,
            "Average": 67.2,
            "Precipitation": 1.88,
            "WindSpeed": 9.5,
            "RelativeHumidity": 59
        }, {
            "Month": "Feb",
            "Low": 60.5,
            "High": 77.7,
            "Average": 68.5,
            "Precipitation": 2.07,
            "WindSpeed": 10.1,
            "RelativeHumidity": 71
        }, {
            "Month": "Mar",
            "Low": 64,
            "High": 80.7,
            "Average": 71.7,
            "Precipitation": 2.56,
            "WindSpeed": 10.5,
            "RelativeHumidity": 69.5
        }, {
            "Month": "Apr",
            "Low": 67.6,
            "High": 83.8,
            "Average": 75.2,
            "Precipitation": 3.36,
            "WindSpeed": 10.5,
            "RelativeHumidity": 67.5
        }, {
            "Month": "May",
            "Low": 72,
            "High": 87.2,
            "Average": 78.7,
            "Precipitation": 5.52,
            "WindSpeed": 9.5,
            "RelativeHumidity": 67
        }, {
            "Month": "Jun",
            "Low": 75.2,
            "High": 89.5,
            "Average": 81.4,
            "Precipitation": 8.54,
            "WindSpeed": 8.3,
            "RelativeHumidity": 71
        }, {
            "Month": "Jul",
            "Low": 76.5,
            "High": 90.9,
            "Average": 82.6,
            "Precipitation": 5.79,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Aug",
            "Low": 76.5,
            "High": 90.6,
            "Average": 82.8,
            "Precipitation": 8.63,
            "WindSpeed": 7.9,
            "RelativeHumidity": 74
        }, {
            "Month": "Sep",
            "Low": 75.7,
            "High": 89,
            "Average": 81.9,
            "Precipitation": 8.38,
            "WindSpeed": 8.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Oct",
            "Low": 72.2,
            "High": 85.4,
            "Average": 78.3,
            "Precipitation": 6.19,
            "WindSpeed": 9.2,
            "RelativeHumidity": 76
        }, {
            "Month": "Nov",
            "Low": 67.5,
            "High": 81.2,
            "Average": 73.6,
            "Precipitation": 3.43,
            "WindSpeed": 9.7,
            "RelativeHumidity": 74
        }, {
            "Month": "Dec",
            "Low": 62.2,
            "High": 77.5,
            "Average": 69.1,
            "Precipitation": 2.18,
            "WindSpeed": 9.2,
            "RelativeHumidity": 73
        }];
        // Since not all the fields in the DataSource are required, we must perform the corresponding bindings
        var fields = chart1.getDataSourceSettings().getFields();
        var fieldPrecipitation = new cfx.FieldMap();
        fieldPrecipitation.setName("Precipitation");
        fieldPrecipitation.setUsage(cfx.FieldUsage.Value);
        fields.add(fieldPrecipitation);
        var MonthField = new cfx.FieldMap();
        MonthField.setName("Month");
        MonthField.setUsage(cfx.FieldUsage.Label);
        fields.add(MonthField);
    
        chart1.setDataSource(items);
    }