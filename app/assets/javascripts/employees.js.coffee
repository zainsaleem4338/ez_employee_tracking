jQuery ->
  $(document).ready ->
    $('#employeeslist_table').DataTable 
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
      	{'width': '5%', 'orderable': false, "className": "text-center"}
      ]