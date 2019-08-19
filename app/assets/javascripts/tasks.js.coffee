# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

employee_options =  {
        preventDuplicates: true,
        hintText: 'Add Employees',
        tokenLimit: 1,
        tokenValue: 'id',
        searchingText: 'searching employees...'}

reviewer_options =  {
        preventDuplicates: true,
        hintText: 'Add reviewer',
        tokenLimit: 1,
        tokenValue: 'id',
        searchingText: 'searching reviewers...'}

team_options =  {
        preventDuplicates: true,
        hintText: 'Add Team',
        tokenLimit: 1,
        tokenValue: 'id',
        searchingText: 'searching teams...'}


jQuery ->
    $(document).ready ->
    $('#taskgrid_table').DataTable 
      'responsive': true,
      'orderClasses': false,
      'paging': false,
      'info': false,
      'columns': [
        {'width': '24%'}
        {'width': '16%',"className": "text-center"}
        {'width': '16%',"className": "text-center"}
        {'width': '16%',"className": "text-center"}
        {'width': '16%',"className": "text-center"}
        {'width': '12%', 'orderable': false, "className": "text-center"}
      ]
    if $('.js-assign-reviewer').val() == ""
      $('.js-assign-reviewer').tokenInput('/employee_lists.json', reviewer_options);
    if $("#assignable_employee_id").val() == ""
      $('#assignable_employee_id').tokenInput('/employee_lists.json', employee_options);
    if $("#assignable_team_id").val() == ""
      $('#assignable_team_id').tokenInput('/teamslist.json', team_options);

    $('.js-toggle-team-employee-input-token').change ->
      $('.js-toggleable-input-token').slideToggle();

    $('.edit_task').submit -> 
      if $("#assignable_employee_id").val() != ""
        $('.js-assignable-id').val($("#assignable_employee_id").val());
        $('.js-assignable-type').val("Employee");
      else if $("#assignable_team_id").val() != ""
        $('.js-assignable-id').val($("#assignable_team_id").val());
        $('.js-assignable-type').val("Team");

    $('.new_task').submit -> 
      if $("#assignable_employee_id").val() != ""
        $('.js-assignable-id').val($("#assignable_employee_id").val());
        $('.js-assignable-type').val("Employee");
      else if $("#assignable_team_id").val() != ""
        $('.js-assignable-id').val($("#assignable_team_id").val());
        $('.js-assignable-type').val("Team");
