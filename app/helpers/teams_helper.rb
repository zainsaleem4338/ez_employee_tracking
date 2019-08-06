module TeamsHelper
  def get_team_leader(team)
    if team.persisted?
      team.employee_lists(Team::EMPLOYEE_TYPE[:team_leader]).map(&:name)[0]
    end
  end
end
