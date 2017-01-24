/* global $, */
//Document ready.
$(document).on('turbolinks:load', function(){
  $('#plan-table-btn').click(function (){
    $('#edit-plan-table').toggle();
  });
});