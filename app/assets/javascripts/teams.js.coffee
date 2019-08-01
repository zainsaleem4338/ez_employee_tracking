# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



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

  $('select#team_department_id').select2({
    placeholder: "Choose a department",
    allowClear: true
  });

  Array::diff = (a) ->
    @filter (i) ->
      a.indexOf(i) < 0

  $ ->

  	$("#add_team_members").click ->
  		$('#team_members_view').show()
  		$('#add_team_members').hide()
  		$('#append_team_members').hide()

  	$("#ok").click ->
      employees = $('#team_employee_ids').val()
      added_employees = $("#append_team_members input")
      addedd_employee_arr = members_array(added_employees)

      employees_arr = employees.split(",")

      employees = employees_arr.diff(addedd_employee_arr)

      team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html()
      team_leader_value = $('#team_team_lead_id').val()

      if(jQuery.inArray( team_leader_value, employees ) != -1)
        $('#team_member_span').text(team_leader+" can't be team member & team leader at the same time.");
      else
        $('#team_employee_ids').tokenInput("clear")
        rows = $('#member_table tr').length + 1
        $.ajax
          type: 'GET'
          url: '/employees/team_member_render_view'
          data: {'employee_ids':employees,'count':rows}
          $('#team_members_view').hide()
          $('#add_team_members').show()
          $('#append_team_members').show()


  	$("#leader_edit").click ->
	    $('#team_leader_field').show()
	    $('#leader').hide()
	    $('#leader_edit').hide()

  	$("#ok_leader").click ->
      team_leader = $('#team_team_lead_id').siblings("ul").find('li p').html()
      team_leader_value = $('#team_team_lead_id').val()
      team_members = $("#append_team_members input")
      team_members_arr = members_array(team_members)
      if(jQuery.inArray( team_leader_value, team_members_arr ) != -1)
        $('#team_leader_span').text(team_leader+" can't be team leader & team member at the same time.");
      else
        $("#leader").text(team_leader)
        $('#team_leader_field').hide()
        $('#leader').show()
        $('#leader_edit').show()
        
        

    $('#append_team_members').on 'click', '.js-remove', ->
      data_member_id = $(this).attr('data-member-id')
      $('#' + data_member_id).remove()
      return
    
    members_array = (employee_arr) ->
      addedd_employee_arr = new Array()
      $.each employee_arr, (key, emp) ->
        addedd_employee_arr.push emp.value
      return addedd_employee_arr
  