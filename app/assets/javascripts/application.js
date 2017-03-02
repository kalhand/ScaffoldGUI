// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//=require jquery
//=require jquery.dataTables.min
//=require jquery
//= require jquery_ujs
//= require highcharts
//= require jquery.simple-dtpicker
//= require_tree .
$.fn.dataTable.ext.errMode = 'none';
//$(document).ready(function() {
  //         EditableTable.init();
    //   });
// $('table').DataTable({
 // sPaginationType: "full_numbers",
 // bJQueryUI: true,
//  bProcessing: true,
//  bServerSide: true,
//  sAjaxSource: $('table').data('source')
// });
//$('table').addClass('table table-striped');
//
//$('#download_data').submit(function(e){
//  alert(456)
//  e.preventDefault();
//  alert(1223)
//});
//
$(function(){
  $('.datetime').appendDtpicker();
});
