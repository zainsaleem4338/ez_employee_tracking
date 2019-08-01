$(document).ready(function(){

  $('#sidebarCollapse').on('click', function () {
    $('#sidebar, #content, #_navbar').toggleClass('active');
  });

  $('#sidebar ul li').on('click', function(){
  	$('#sidebar ul li').removeClass('active');
  	$(this).addClass('active');
  });

});
