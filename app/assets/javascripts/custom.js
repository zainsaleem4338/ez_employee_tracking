$(document).ready(function() {
  $('#company-name').on('input',function(e){
    $("#company-subdomain").val($(this).val().toLowerCase());
})});

