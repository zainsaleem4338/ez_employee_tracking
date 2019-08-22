(function() {
  jQuery(function() {
    return $(document).ready(function() {
      var get_field_values;
      $('#task_table').DataTable({
        'scrollX': true,
        "paging": false,
        "ordering": false,
        "info": false
      });
      get_field_values = function() {
        return {
          project: $('#project').val(),
          status: $('#status').val(),
          created_start: $('#created_start').val(),
          created_end: $('#created_end').val(),
          deadline_start: $('#deadline_start').val(),
          deadline_end: $('#deadline_end').val()
        };
      };
      $("#update").click(function() {
        var fields;
        fields = get_field_values();
        if (fields['project'] !== "" || fields['status'] !== "" || fields['created_start'] !== "" || fields['created_end'] !== "" || fields['deadline_start'] !== "" || fields['deadline_end'] !== "") {
          if (fields['created_start'] !== "" && fields['created_end'] !== "") {
            if (fields['created_start'] > fields['created_end']) {
              return $('#created_date_range').text("Invalid Start Date Range");
            } else {
              $('#created_date_range').remove();
            }
          }
          if (fields['deadline_start'] !== "" && fields['deadline_end'] !== "") {
            if (fields['deadline_start'] > fields['deadline_end']) {
              return $('#deadline_date_range').text("Invalid Expected Date Range");
            } else {
              $('#deadline_date_range').remove();
            }
          }
          return $.ajax({
            type: 'GET',
            url: '/reports/load_task_data_in_report.js',
            data: {
              'project': fields['project'],
              'status': fields['status'],
              'created_start': fields['created_start'],
              'created_end': fields['created_end'],
              'deadline_start': fields['deadline_start'],
              'deadline_end': fields['deadline_end']
            }
          });
        }
      });
      return $("#clear").click(function() {
        $('#project').val('');
        $('#status').val('');
        $('#created_start').val('');
        $('#created_end').val('');
        $('#deadline_start').val('');
        $('#deadline_end').val('');
        $('#deadline_date_range').remove();
        return $('#created_date_range').remove();
      });
    });
  });

}).call(this);
