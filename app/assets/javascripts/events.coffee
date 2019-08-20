jQuery ->
  $(document).ready ->
    $('#event_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
      	{'width': '25%',"className": "text-center"}
      	{'width': '25%',"className": "text-center"}
      	{'width': '25%',"className": "text-center"}
      	{'width': '25%', 'orderable': false, "className": "text-center"}
      ]