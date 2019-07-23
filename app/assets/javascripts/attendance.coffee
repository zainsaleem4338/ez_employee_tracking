# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	$('#attendance_id').click ->
	  attendance_list = document.getElementById("admin_attendance");
	  calendar = document.getElementById("admin_calendar");
	  attendance_list.style.display = "flex";
	  calendar.style.display = "none";


