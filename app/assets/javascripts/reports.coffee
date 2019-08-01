# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $(document).ready ->
    $('#task_table').DataTable 
      'scrollX': true,
      "paging":   false,
      "ordering": false,
      "info":     false

    $("#update").click ->
      project = $('#project').val()
      status = $('#status').val()
      created_start = $('#created_start').val()
      created_end = $('#created_end').val()
      deadline_start = $('#deadline_start').val()
      deadline_end = $('#deadline_end').val()
      if project != "" || status != "" || created_start != "" || created_end != "" || deadline_start != "" || deadline_end != ""
        if created_start != "" && created_end != ""
          if created_start > created_end
            return $('#created_date_range').text("Invalid Created Date Range")
          else
            $('#created_date_range').remove()
        if deadline_start != "" && deadline_end != ""
          if deadline_start > deadline_end
            return $('#deadline_date_range').text("Invalid Deadline Date Range")
          else
            $('#deadline_date_range').remove()
        $.ajax
          type: 'GET'
          url: '/reports/load_task_data_in_report.js'
          data: {'project':project,'status':status,'created_start':created_start,'created_end':created_end,'deadline_start':deadline_start,'deadline_end':deadline_end}


    $("#clear").click ->
      $('#project').val('')
      $('#status').val('')
      $('#created_start').val('')
      $('#created_end').val('')
      $('#deadline_start').val('')
      $('#deadline_end').val('')