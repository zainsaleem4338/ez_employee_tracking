jQuery ->
  department_id = $('#department').val()
  user_hash = {
  theme: 'facebook',
  crossDomain: false,
  preventDuplicates: true }
    
  $('#team_members_view').hide()
  $('#team_leader_field').hide()
  $('#team_employee_ids').tokenInput '/employee_lists.json?department='+department_id, Object.assign({ prePopulate: $('#team_employee_ids').data('load') }, user_hash)
  $('#team_team_lead_id').tokenInput '/employee_lists.json?department='+department_id, Object.assign({ tokenLimit: 1, prePopulate: $('#team_team_lead_id').data('load') }, user_hash)
  
  Array::diff = (a) ->
    @filter (i) ->
      a.indexOf(i) < 0

  $ ->
    $("#add_team_members").click ->
      $('#team_members_view').show()
      $('#add_team_members').hide()
      $('.append-team-members').hide()

    $("#ok").click ->
      employees = $('#team_employee_ids').val()
      added_employees = $(".append-team-members input")
      added_employee_arr = members_array(added_employees)
      employees_arr = employees.split(",")
      employees = employees_arr.diff(added_employee_arr)
      team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html()
      team_leader_value = $('#team_team_lead_id').val()
      if(jQuery.inArray( team_leader_value, employees ) != -1)
        if(team_leader_value != "")
          $('#team_member_span').text(team_leader+" can't be team member & team leader at the same time.");
      else
        $('#team_employee_ids').tokenInput("clear")
        rows = $('#member_table tr').length + 1
        $.ajax
          type: 'GET'
          url: '/teams/team_members'
          data: {'employee_ids':employees,'count':rows}
          $('#team_members_view').hide()
          $('#add_team_members').show()
          $('.append-team-members').show()
          $('#team_member_span').text("");


    $("#leader_edit").click ->
      $('#team_leader_field').show()
      $('#leader').hide()
      $('#leader_edit').hide()

    $("#ok_leader").click ->
      team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html()
      team_leader_value = $('#team_team_lead_id').val()
      team_members = $(".append-team-members input")
      team_members_arr = members_array(team_members)
      if(jQuery.inArray( team_leader_value, team_members_arr ) != -1)
        $('#team_leader_span').text(team_leader+" can't be team leader & team member at the same time.");
      else
        $("#leader").text(team_leader)
        $('#team_leader_field').hide()
        $('#leader').show()
        $('#leader_edit').show()
        $('#team_leader_span').text("")

    $('.append-team-members').on 'click', '.js-remove', ->
      data_member_id = $(this).attr('data-member-id')
      $('#team_employee_teams_attributes_2__destroy').val(true)
      $('#' + data_member_id).remove()
      return
    
    members_array = (employee_arr) ->
      added_employee_new_arr = new Array()
      $.each employee_arr, (key, employee) ->
        added_employee_new_arr.push employee.value
      return added_employee_new_arr

    $('#teams_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
        {'width': '17%',"className": "text-center"}
        {'width': '17%',"className": "text-center"}
        {'width': '17%',"className": "text-center"}
        {'width': '17%',"className": "text-center"}
        {'width': '15%', 'orderable': false,"className": "text-center"}
      ]
