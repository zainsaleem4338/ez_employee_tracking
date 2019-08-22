jQuery ->
  $(document).ready ->
    $('#department_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
      	{'width': '45%'}
      	{'width': '20%', 'orderable': false, "className": "text-center"}
        {'width': '20%', 'orderable': false, "className": "text-center"}
        {'width': '15%', 'orderable': false, "className": "text-center"}
      ]
