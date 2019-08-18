(function() {
  jQuery(function() {
    var department_id, user_hash;
    department_id = $('#department').val();
    user_hash = {
      theme: 'facebook',
      crossDomain: false,
      preventDuplicates: true
    };
    $('#team_members_view').hide();
    $('#team_leader_field').hide();
    $('#team_employee_ids').tokenInput('/employee_lists.json?department=' + department_id, Object.assign({
      prePopulate: $('#team_employee_ids').data('load')
    }, user_hash));
    $('#team_team_lead_id').tokenInput('/employee_lists.json?department=' + department_id, Object.assign({
      tokenLimit: 1,
      prePopulate: $('#team_team_lead_id').data('load')
    }, user_hash));
    Array.prototype.diff = function(a) {
      return this.filter(function(i) {
        return a.indexOf(i) < 0;
      });
    };
    return $(function() {
      var members_array;
      $("#add_team_members").click(function() {
        $('#team_members_view').show();
        $('#add_team_members').hide();
        return $('#append_team_members').hide();
      });
      $("#ok").click(function() {
        var added_employee_arr, added_employees, employees, employees_arr, rows, team_leader, team_leader_value;
        employees = $('#team_employee_ids').val();
        added_employees = $("#append_team_members input");
        added_employee_arr = members_array(added_employees);
        employees_arr = employees.split(",");
        employees = employees_arr.diff(added_employee_arr);
        team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html();
        team_leader_value = $('#team_team_lead_id').val();
        if (jQuery.inArray(team_leader_value, employees) !== -1) {
          return $('#team_member_span').text(team_leader + " can't be team member & team leader at the same time.");
        } else {
          $('#team_employee_ids').tokenInput("clear");
          rows = $('#member_table tr').length + 1;
          return $.ajax({
            type: 'GET',
            url: '/employees/team_member_render_view',
            data: {
              'employee_ids': employees,
              'count': rows
            }
          }, $('#team_members_view').hide(), $('#add_team_members').show(), $('#append_team_members').show(), $('#team_member_span').text(""));
        }
      });
      $("#leader_edit").click(function() {
        $('#team_leader_field').show();
        $('#leader').hide();
        return $('#leader_edit').hide();
      });
      $("#ok_leader").click(function() {
        var team_leader, team_leader_value, team_members, team_members_arr;
        team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html();
        team_leader_value = $('#team_team_lead_id').val();
        team_members = $("#append_team_members input");
        team_members_arr = members_array(team_members);
        if (jQuery.inArray(team_leader_value, team_members_arr) !== -1) {
          return $('#team_leader_span').text(team_leader + " can't be team leader & team member at the same time.");
        } else {
          $("#leader").text(team_leader);
          $('#team_leader_field').hide();
          $('#leader').show();
          $('#leader_edit').show();
          return $('#team_leader_span').text("");
        }
      });
      $('#append_team_members').on('click', '.js-remove', function() {
        var data_member_id;
        data_member_id = $(this).attr('data-member-id');
        $('#' + data_member_id).remove();
      });
      return members_array = function(employee_arr) {
        var added_employee_new_arr;
        added_employee_new_arr = new Array();
        $.each(employee_arr, function(key, employee) {
          return added_employee_new_arr.push(employee.value);
        });
        return added_employee_new_arr;
      };
    });
  });

}).call(this);
