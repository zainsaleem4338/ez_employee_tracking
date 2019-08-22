$(document).ready(function(){

  $('#filter_btn').on('click', function() {
    $(this).find('i').toggleClass('d-none')
    $(this).find('p').toggleClass('d-none')
  });

});