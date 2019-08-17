jQuery ->
  $(document).ready ->
    $('#project_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
      	{'width': '36%'}
      	{'width': '16%',"className": "text-center"}
      	{'width': '20%',"className": "text-center"}
      	{'width': '16%',"className": "text-center"}
      	{'width': '16%', 'orderable': false, "className": "text-center"}
      ]