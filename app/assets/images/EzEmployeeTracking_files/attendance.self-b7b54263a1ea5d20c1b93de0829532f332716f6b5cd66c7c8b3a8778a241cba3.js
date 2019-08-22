(function() {
  jQuery(function() {
    $('#attendance_id').click(function() {
      var attendance_list, calendar;
      attendance_list = document.getElementById("admin_attendance");
      calendar = document.getElementById("admin_calendar");
      attendance_list.style.display = "flex";
      return calendar.style.display = "none";
    });
    return $('#admin_calendar').click(function() {
      var attendance_list, calendar;
      attendance_list = document.getElementById("admin_attendance");
      calendar = document.getElementById("admin_calendar");
      attendance_list.style.display = "none";
      return calendar.style.display = "flex";
    });
  });

}).call(this);
