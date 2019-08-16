$( document ).ready(function() {

  $(".spinner").hide();

  $(document).ajaxStart(function(){
    $(".spinner").show();
  });

  $(document).ajaxStop(function(){
    $(".spinner").delay(3000).hide(0);
  });

});