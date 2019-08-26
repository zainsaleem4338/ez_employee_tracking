class Team < ActiveRecord::Base
  EMPLOYEE_TYPE = { team_member: 'Team Member', team_leader: 'Team Leader' }.freeze
  attr_reader :employee_tokens, :team_lead_id
  belongs_to :department
  belongs_to :company
  has_many :employee_teams
  has_many :employees, through: :employee_teams, dependent: :destroy
  accepts_nested_attributes_for :employee_teams, allow_destroy: true
  has_attached_file :team_pic, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: "/assets/team.png"
  validates_attachment_content_type :team_pic, content_type: /\Aimage\/.*\z/
  has_many :tasks, as: :assignable, dependent: :destroy
  scope :show_teams_employee, ->(user) { where(id: user.teams.pluck(:id)) }

  def create_team(department_id, employee_ids)
    self.add_errors(employee_ids)
    if self.errors.count == 0
      self.department_id = department_id
      self.save
      return self
    else
      false
    end
  end

  def update_team(employee_ids, team_params)
    self.add_errors(employee_ids)
    if self.errors.count == 0
      self.update(team_params)
      return self
    else
      false
    end
  end

  def add_errors(employee_ids)
    team_lead_id = 0
    if self.name.blank?
      self.errors.add(:base, I18n.t('models.team.team_name_require'))
    end
    if employee_ids.count.zero?
      self.errors.add(:base, I18n.t('models.team.team_members_and_leader_name_require'))
    else
      self.employee_teams.each do |employee_team|
        if employee_team.employee_id.blank? && employee_team.employee_type == EMPLOYEE_TYPE[:team_leader]
          self.errors.add(:base, I18n.t('models.team.leader_name_require'))
        elsif employee_team.employee_type == EMPLOYEE_TYPE[:team_leader]
          team_lead_id = employee_team.employee_id
        end
      end
    end
    if employee_ids.count == 1
      self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
    end
    unless team_lead_id.zero?
      self.employee_teams.each do |employee_team|
        if employee_team.employee_type == EMPLOYEE_TYPE[:team_member]
          if employee_team.employee_id == team_lead_id
            self.errors.add(:base, I18n.t('models.team.team_lead_member_conflict'))
            break
          end
        end
      end
    end
  end

  def employee_lists(employee_type)
    self.employees.where(employee_teams: { employee_type: employee_type })
  end

  def self.deparment_teams(current_employee, department_id)
    current_employee.company.departments.find(department_id).teams
  end

  def with_employee_teams
    employee_teams.build if employee_teams.blank?
    self
  end
end
