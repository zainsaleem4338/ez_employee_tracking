jQuery ->
  $(document).ready ->
    $('#department_table').DataTable 
      'scrollX': true,
      "paging":   false,
      "info":     false,
      "orderable": true,
      "autoWidth": false,
      "responsive": true