$(document).ready(function() {
  $('#company-name').on('input',function(e){
    $("#company-subdomain").val($(this).val().toLowerCase());
})});


function send(data) {
  var chatinput = document.getElementById("chat-input");
  var chatoutput = document.getElementById("chat-output");
  var textstyle = document.querySelector(".text");

  chatoutput.innerText += data ;
  chatinput.value = "";

  // Style
  textstyle.style.backgroundColor = "#ffd692";
  textstyle.style.color = "#6e2142";
  textstyle.style.padding = "10px 20px";
  textstyle.style.borderRadius = "5px";

}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

// Setting

$( document ).ready(function() {
  $('#monday_start_time').timepicki();
  $('#monday_end_time').timepicki();
  $('#tuesday_start_time').timepicki();
  $('#tuesday_end_time').timepicki();
  $('#wednesday_start_time').timepicki();
  $('#wednesday_end_time').timepicki();
  $('#thursday_start_time').timepicki();
  $('#thursday_end_time').timepicki();
  $('#friday_start_time').timepicki();
  $('#friday_end_time').timepicki();
  $('#saturday_start_time').timepicki();
  $('#saturday_end_time').timepicki();
  $('#sunday_start_time').timepicki();
  $('#sunday_end_time').timepicki();  

   $('#save_btn').click(function() {
       var obj = {}; 
      var count = 1;
       while($('#holiday_date_'+count).val()!== undefined){
         if ($('#holiday_date_'+count).val() !== ""){
           var public_holiday = {};
          public_holiday['holiday_date_'+count] = $('#holiday_date_'+count).val(); 
           if ($('#every_year_'+count+':checkbox:checked').length > 0) {
             public_holiday['every_year_'+count] = true;
           }
           else{
             public_holiday['every_year_'+count] = false;
           }
           obj[count] = public_holiday;
           public_holiday = {};
         }
         else{
           break;
         }
         count += 1;
       }
       $('#holidays').val(JSON.stringify(obj));
   });

});



