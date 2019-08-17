jQuery ->
  $(document).ready ->
    $('#department_table').DataTable 
      'scrollX': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
      	{'width': '70%'}
      	{'width': '30%', 'orderable': false}
      ]