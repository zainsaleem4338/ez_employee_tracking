# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hash_new =  {
        preventDuplicates: true,
        hintText: 'Add Employees',
        tokenLimit: 1,
        tokenValue: 'id',
        prePopulate: $('#team_assignable_id').data('load'),
        searchingText: 'searching employees...'}

hash_new_team =  {
        preventDuplicates: true,
        hintText: 'Add Team',
        tokenLimit: 1,
        tokenValue: 'id',
        prePopulate: $('#team_assignable_id').data('load'),
        searchingText: 'searching teams...'}


jQuery ->
    $(document).ready ->
      $('.assign_team').tokenInput('/teamslist.json', hash_new);
      $('.assign_employee').tokenInput('/employeeslist.json', hash_new);

    
    $('.js-toggle-team-employee-input-token').change ->
      $('.js-toggleable-input-token').slideToggle();
      $('.assignable_type').val($(this).data('type'));
   
      