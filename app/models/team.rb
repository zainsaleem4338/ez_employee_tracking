class Team < ActiveRecord::Base
  attr_reader :employee_tokens, :team_lead_id
  belongs_to :department
  belongs_to :company
  has_many :employee_teams
  has_many :employees, through: :employee_teams, dependent: :destroy
  validates :name, :department_id, presence: true

  def create_team(team_lead_id, employee_ids)
    team_members_ids = employee_ids(employee_ids)
    begin
      self.transaction do
        self.save!
        self.employee_teams.create!(employee_id: team_lead_id, employee_type: 'Team Leader')
        if team_members_ids.empty?
          self.errors.add(:base, 'Team members name required')
          return false
        end
        team_members_ids.each do |team_member|
          self.employee_teams.create!(employee_id: team_member, employee_type: 'Team Member')
        end
        return self
      end
    rescue ActiveRecord::RecordInvalid => e
      if e.record.is_a? EmployeeTeam
        if e.record.employee_id.nil? && e.record.employee_type == 'Team Leader'
          self.errors.add(:base, 'Team leader name is required')
        end
        if e.record.employee_id.nil? && e.record.employee_type == 'Team Member'
          self.errors.add(:base, 'Team member names are required')
        end
      end
      false
    rescue Exception
      false
    end
  end

  def update_team(team_lead_id, employee_ids)
    team_members_ids = employee_ids(employee_ids)
    begin
      self.transaction do
        self.save!
        team_employees = self.employee_teams
        team_lead = team_employees.find_by(employee_type: 'Team Leader')
        team_members = team_employees.where(employee_type: 'Team Member').pluck(:employee_id)
        team_lead_query = team_employees.where(employee_id: team_lead_id)
        # previous team leader delete
        team_lead.delete if team_lead_query.empty? && team_lead.present?
        team_lead_query.first_or_create!(employee_type: 'Team Leader')
        if team_members_ids.empty?
          self.errors.add(:base, 'Team members name required')
          return false
        end
        # find previous team members id by subtract with updated members
        previous_team_member_ids = team_members - team_members_ids
        # delete team members
        previous_team_member_ids.each do |member_id|
          team_employees.find_by(employee_id: member_id).delete
        end
        team_members_ids.each do |team_member|
          team_employees.where(employee_id: team_member).first_or_create!(employee_type: 'Team Member')
        end
        return self
      end
    rescue ActiveRecord::RecordInvalid => e
      if e.record.is_a? EmployeeTeam
        if e.record.employee_id.nil? && e.record.employee_type == 'Team Leader'
          self.errors.add(:base, 'Team leader name is required')
        end
        if e.record.employee_id.nil? && e.record.employee_type == 'Team Member'
          self.errors.add(:base, 'Team member names are required')
        end
      end
      false
    rescue Exception
      false
    end
  end

  def employee_ids(employee_ids)
    employee_ids.split(',').map(&:to_i)
  end

  def employee_lists(employee_type)
    self.employees.where(employee_teams: { employee_type: employee_type })
  end
end
