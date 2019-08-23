jQuery ->
  $(document).ready ->

    get_field_values = ->
     {  
        project: $('#project').val()
        status: $('#status').val()
        created_start: $('#created_start').val()
        created_end: $('#created_end').val()
        deadline_start: $('#deadline_start').val()
        deadline_end: $('#deadline_end').val()
      }

    $("#update").click ->
      fields = get_field_values()
      if fields['project'] != "" || fields['status'] != "" || fields['created_start'] != "" || fields['created_end'] != "" || fields['deadline_start'] != "" || fields['deadline_end'] != ""
        if fields['created_start'] != "" && fields['created_end'] != ""
          if fields['created_start'] > fields['created_end']
            return $('#created_date_range').text("Invalid Start Date Range")
          else
            $('#created_date_range').remove()
        if fields['deadline_start'] != "" && fields['deadline_end'] != ""
          if fields['deadline_start'] > fields['deadline_end']
            return $('#deadline_date_range').text("Invalid Expected Date Range")
          else
            $('#deadline_date_range').remove()
        $.ajax
          type: 'GET'
          url: '/reports/load_task_data_in_report.js'
          data: {'project':fields['project'],'status':fields['status'],'created_start':fields['created_start'],'created_end':fields['created_end'],'deadline_start':fields['deadline_start'],'deadline_end':fields['deadline_end']}
    
    $("#clear").click ->
      $('#project').val('')
      $('#status').val('')
      $('#created_start').val('')
      $('#created_end').val('')
      $('#deadline_start').val('')
      $('#deadline_end').val('')
      $('#deadline_date_range').remove()
      $('#created_date_range').remove()

    $('#attendancereport_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
        {'width': '5%',"className": "text-center"}
        {'width': '15%',"className": "text-center"}
        {'width': '20%',"className": "text-center"}
        {'width': '15%',"className": "text-center"}
        {'width': '15%',"className": "text-center"}
        {'width': '15%',"className": "text-center"}
        {'width': '15%',"className": "text-center"}
      ]

    $('#team-task-details').click ->
      $('#velocityreport_table').DataTable 
        'responsive': true,
        'orderClasses': false,
        'paging': false,
        'info': false,
        'columns': [
          {'width': '5%',"className": "text-center"}
          {'width': '17%',"className": "text-center"}
          {'width': '17%',"className": "text-center"}
          {'width': '17%',"className": "text-center"}
          {'width': '17%',"className": "text-center"}
          {'width': '17%',"className": "text-center"}
        ]

    $('#teamstasks_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
        {'width': '5%',"className": "text-center", "orderable": false}
        {'width': '30%',"className": "text-center"}
        {'width': '20%',"className": "text-center"}
        {'width': '20%',"className": "text-center"}
        {'width': '20%',"className": "text-center"}
        {'width': '5%', "orderable": false}
      ]


  $('#taskdetails_table').DataTable 
    'responsive': true,
    'orderClasses': false,
    'paging': false,
    'info': false,
    'columns': [
      {'width': '20%'}
      {'width': '20%'}
      {'width': '13%'}
      {'width': '13%'}
      {'width': '12%',"className": "text-center"}
      {'width': '12%',"className": "text-center"}
      {'width': '10%',"className": "text-center"}
    ]