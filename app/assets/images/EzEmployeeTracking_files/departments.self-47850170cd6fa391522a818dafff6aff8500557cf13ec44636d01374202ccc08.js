(function() {
  jQuery(function() {
    return $(document).ready(function() {
      return $('#department_table').DataTable({
        'scrollX': true,
        "paging": false,
        "info": false,
        "orderable": true,
        "autoWidth": false,
        "responsive": true
      });
    });
  });

}).call(this);
