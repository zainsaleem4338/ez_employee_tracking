# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hash_new =  {
        preventDuplicates: true,
        hintText: 'Add Employees',
        tokenLimit: 1,
        tokenValue: 'id',
        searchingText: 'searching employees...'}

hash_new_team =  {
        preventDuplicates: true,
        hintText: 'Add Team',
        tokenLimit: 1,
        tokenValue: 'id',
        searchingText: 'searching teams...'}


jQuery ->
    $(document).ready ->
    if $("#assignable_employee_id").val() == ""
      $('#assignable_employee_id').tokenInput('/employee_lists.json', hash_new);
    if $("#assignable_team_id").val() == ""
      $('#assignable_team_id').tokenInput('/teamslist.json', hash_new_team);

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