# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hash_new =  {
        preventDuplicates: true,
        hintText: 'Add Employees',
        tokenLimit: 1,
        tokenValue: 'id',
        prePopulate: $('.assign_team').data('load'),
        searchingText: 'searching employees...'}

hash_new_team =  {
        preventDuplicates: true,
        hintText: 'Add Team',
        tokenLimit: 1,
        tokenValue: 'id',
        prePopulate: $('.assign_team').data('load'),
        searchingText: 'searching teams...'}


jQuery ->
    $(document).ready ->
      $('.assign_team').tokenInput('/employeeslist.json', hash_new);

    
    $('.js-toggle-team-employee-input-token').change ->
      $('.js-toggleable-input-token').slideToggle();
      $('.token-input-list').remove();
      if ($(this).data('type') == 'Employee') 
        $('.assign_team').tokenInput('/employeeslist.json',hash_new);
      else if($(this).data('type') == 'Team') 
        $('.assign_team').tokenInput('/teamslist.json',hash_new_team);
      $('.assignable_type').val($(this).data('type'));
   
      