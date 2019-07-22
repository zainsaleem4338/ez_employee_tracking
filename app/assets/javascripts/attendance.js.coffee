
$('attendance_id').click ->
  attendance_list = document.getElementById("admin_attendance")
  calendar = document.getElementById("admin_calendar")
  attendance_list.style.display = "none"
  calendar.style.display = "flex"

$('calendar_id').click ->
  calendar = document.getElementById("admin_calendar")
  attendance_list = document.getElementById("admin_attendance")
  calendar.style.display = "none"
  attendance_list.style.display = "flex"
