function initChart(id, text, data){
	var chart = new cfx.Chart();
    chart.create(id);
    chart.setGallery(cfx.Gallery.Bar);
    chart.setDataSource(data);
    chart.getView3D().setEnabled(true);
    chart.getAllSeries().setMultipleColors(true);
    title = new cfx.TitleDockable();
    title.setText(text);
    chart.getTitles().add(title);
}


