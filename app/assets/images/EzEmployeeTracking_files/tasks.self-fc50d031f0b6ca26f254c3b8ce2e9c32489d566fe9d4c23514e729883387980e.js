(function() {
  var employee_options, reviewer_options, team_options;

  employee_options = {
    preventDuplicates: true,
    hintText: 'Add Employees',
    tokenLimit: 1,
    tokenValue: 'id',
    searchingText: 'searching employees...'
  };

  reviewer_options = {
    preventDuplicates: true,
    hintText: 'Add reviewer',
    tokenLimit: 1,
    tokenValue: 'id',
    searchingText: 'searching reviewers...'
  };

  team_options = {
    preventDuplicates: true,
    hintText: 'Add Team',
    tokenLimit: 1,
    tokenValue: 'id',
    searchingText: 'searching teams...'
  };

  jQuery(function() {
    $(document).ready(function() {});
    if ($('.js-assign-reviewer').val() === "") {
      $('.js-assign-reviewer').tokenInput('/employee_lists.json', reviewer_options);
    }
    if ($("#assignable_employee_id").val() === "") {
      $('#assignable_employee_id').tokenInput('/employee_lists.json', employee_options);
    }
    if ($("#assignable_team_id").val() === "") {
      $('#assignable_team_id').tokenInput('/teamslist.json', team_options);
    }
    $('.js-toggle-team-employee-input-token').change(function() {
      return $('.js-toggleable-input-token').slideToggle();
    });
    $('.edit_task').submit(function() {
      if ($("#assignable_employee_id").val() !== "") {
        $('.js-assignable-id').val($("#assignable_employee_id").val());
        return $('.js-assignable-type').val("Employee");
      } else if ($("#assignable_team_id").val() !== "") {
        $('.js-assignable-id').val($("#assignable_team_id").val());
        return $('.js-assignable-type').val("Team");
      }
    });
    return $('.new_task').submit(function() {
      if ($("#assignable_employee_id").val() !== "") {
        $('.js-assignable-id').val($("#assignable_employee_id").val());
        return $('.js-assignable-type').val("Employee");
      } else if ($("#assignable_team_id").val() !== "") {
        $('.js-assignable-id').val($("#assignable_team_id").val());
        return $('.js-assignable-type').val("Team");
      }
    });
  });

}).call(this);
