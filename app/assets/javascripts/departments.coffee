jQuery ->
  $(document).ready ->
    $('#department_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
      	{'width': '70%'}
      	{'width': '30%', 'orderable': false, "className": "text-center"}
      ]
