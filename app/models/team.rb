class Team < ActiveRecord::Base
  EMPLOYEE_TYPE = { team_member: 'Team Member', team_leader: 'Team Leader' }.freeze
  attr_reader :employee_tokens, :team_lead_id
  belongs_to :department
  belongs_to :company
  has_many :employee_teams
  has_many :employees, through: :employee_teams, dependent: :destroy
  validates :name, presence: :true
  accepts_nested_attributes_for :employee_teams, allow_destroy: true
  has_attached_file :team_pic, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: "/assets/team.png"
  validates_attachment_content_type :team_pic, content_type: /\Aimage\/.*\z/
  has_many :tasks, as: :assignable, dependent: :destroy
  scope :show_teams_employee, ->(user) { where(id: user.teams.pluck(:id)) }
  validate :validate_team

  def validate_team
    if employee_teams.length.zero?
      errors.add(:base, I18n.t('models.team.team_members_and_leader_name_require'))
    else
      lead = employee_teams.detect { |employee_team| employee_team.employee_type == EMPLOYEE_TYPE[:team_leader] }
      if lead.employee_id.blank?
        errors.add(:base, I18n.t('models.team.leader_name_require'))
      else
        members = employee_teams.select { |employee_team| employee_team.employee_type == EMPLOYEE_TYPE[:team_member] }
        members.each do |employee_team|
          if employee_team.employee_id == lead.employee_id
            errors.add(:base, I18n.t('models.team.team_lead_member_conflict'))
            break
          end
        end
      end
    end
    if employee_teams.length == 1
      errors.add(:base, I18n.t('models.team.team_members_require_error'))
    end
  end

  def employee_lists(employee_type)
    self.employees.where(employee_teams: { employee_type: employee_type })
  end

  def self.deparment_teams(current_employee, department_id)
    current_employee.company.departments.find(department_id).teams
  end

  def build_employee_teams
    employee_teams.build if employee_teams.blank?
    self
  end
end
