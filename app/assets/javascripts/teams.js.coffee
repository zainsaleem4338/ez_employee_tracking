# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

user_hash = {
  theme: 'facebook',
  crossDomain: false,
  queryParam: "term",
  preventDuplicates: true }

jQuery ->
  $(document).ready ->
    
    $('#team_employee_tokens').tokenInput '/employee_lists.json', Object.assign({ prePopulate: $('#team_employee_tokens').data('load') }, user_hash)

    $('#team_team_lead_id').tokenInput '/employee_lists.json', Object.assign({ tokenLimit: 1, prePopulate: $('#team_team_lead_id').data('load') }, user_hash)

    $('select#team_department_id').select2({
      placeholder: "Choose a department",
      allowClear: true
    });
  
  