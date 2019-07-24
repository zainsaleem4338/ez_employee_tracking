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
      $('.js-assign-team').tokenInput('/teamslist.json', hash_new);
      $('.js-assign-employee').tokenInput('/employee_lists.json', hash_new_team);

    
    $('.js-toggle-team-employee-input-token').change ->
      $('.js-toggleable-input-token').slideToggle();
      $('.js-assignable_type').val($(this).data('type'));
   
      