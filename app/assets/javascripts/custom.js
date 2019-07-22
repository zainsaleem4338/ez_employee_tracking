$(document).ready(function() {
  $('#company-name').on('input',function(e){
    var data = $(this);
    $("#company-subdomain").val(data.val().toLowerCase());
})});

