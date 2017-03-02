//$("table").attr("id", "editable-sample");
$("table").addClass("table table-striped table-hover table-bordered");

    $('table th').each(function() {
    var cellText = $(this).html(); 
	$(this).removeAttr("colspan");
    });
$(document).ready(function(){
$("table tbody tr td").each(function(){
	$("table td:contains('Show')").remove();
	$("table td:contains('Destroy')").remove();

});
});

$('table').DataTable({
    sPaginationType: "full_numbers",
  //    bJQueryUI: true,
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: $('table').data('source')
});
  
