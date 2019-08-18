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
  textstyle.style.backgroundColor = "#89d3ff";
  textstyle.style.color = "#fff";
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

// Meter



