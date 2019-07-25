# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

user_hash = {
  theme: 'facebook',
  crossDomain: false,
  queryParam: "term",
  preventDuplicates: true }

jQuery ->
    
    $('#team_members_view').hide()
    $('#team_leader_field').hide()
    $('#team_employee_ids').tokenInput '/employee_lists.json', Object.assign({ prePopulate: $('#team_employee_ids').data('load') }, user_hash)

    $('#team_team_lead_id').tokenInput '/employee_lists.json', Object.assign({ tokenLimit: 1, prePopulate: $('#team_team_lead_id').data('load') }, user_hash)

    $('select#team_department_id').select2({
      placeholder: "Choose a department",
      allowClear: true
    });

$ ->

	$("#add_team_members").click ->
		$('#team_members_view').show()
		$('#add_team_members').hide()
		$('#append_team_members').hide()

	$("#ok").click ->
	    employees = $('#team_employee_ids').val()
	    $('#team_employee_ids').tokenInput("clear");
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
	    $("#leader").text(team_leader);
	    $('#team_leader_field').hide()
	    $('#leader').show()
	    $('#leader_edit').show()

    $('#append_team_members').on 'click', '.js-remove', ->
      data_member_id = $(this).attr('data-member-id')
      $('#' + data_member_id).remove()
      return
  
  