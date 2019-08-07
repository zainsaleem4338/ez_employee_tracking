class Team < ActiveRecord::Base
  EMPLOYEE_TYPE = { team_member: 'Team Member', team_leader: 'Team Leader' }.freeze
  attr_reader :employee_tokens, :team_lead_id
  belongs_to :department
  belongs_to :company
  has_many :employee_teams
  has_many :employees, through: :employee_teams, dependent: :destroy
  validates :name, :department_id, presence: true
  has_attached_file :team_pic, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: "/assets/team.png"
  validates_attachment_content_type :team_pic, content_type: /\Aimage\/.*\z/
  has_many :tasks, as: :assignable, dependent: :destroy
  scope :show_teams_employee, ->(user){ where(id: user.teams.pluck(:id)) }
  def create_team(team_lead_id, employee_ids, department_id)
    if employee_ids.blank?
      self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
      return false
    end
    team_members_ids = employee_ids.map(&:to_i)
    if team_lead_id.present?
      if team_members_ids.include? team_lead_id.to_i
        self.errors.add(:base, I18n.t('models.team.team_lead_member_conflict'))
        return false
      end
    end
    begin
      self.department_id = department_id
      self.transaction do
        self.save!
        self.employee_teams.create!(employee_id: team_lead_id, employee_type: EMPLOYEE_TYPE[:team_leader])
        if team_members_ids.empty?
          self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
          return false
        end
        team_members_ids.each do |team_member|
          self.employee_teams.create!(employee_id: team_member, employee_type: EMPLOYEE_TYPE[:team_member])
        end
        return self
      end
    rescue ActiveRecord::RecordInvalid => error
      self.add_errors(error)
      false
    rescue Exception
      false
    end
  end

  def update_team(team_lead_id, employee_ids, update_team_params)
    if employee_ids.blank?
      self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
      return false
    end
    team_members_ids = employee_ids.map(&:to_i)
    if team_lead_id.present?
      if team_members_ids.include? team_lead_id.to_i
        self.errors.add(:base, I18n.t('models.team.team_lead_member_conflict'))
        return false
      end
    end
    begin
      if team_members_ids.empty?
        self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
        return false
      end
      team_employees = self.employee_teams
      team_lead = team_employees.find_by(employee_type: EMPLOYEE_TYPE[:team_leader])
      team_members = team_employees.where(employee_type: EMPLOYEE_TYPE[:team_member]).map(&:employee_id)
      team_lead_query = team_employees.where(employee_id: team_lead_id)
      team_lead.delete if team_lead_query.empty? && team_lead.present?
      previous_team_member_ids = team_members - team_members_ids
      self.transaction do
        self.update!(update_team_params)
        team_lead_query.first_or_create!(employee_type: EMPLOYEE_TYPE[:team_leader])
        previous_team_member_ids.each do |member_id|
          team_employees.find_by(employee_id: member_id).delete
        end
        team_members_ids.each do |team_member|
          team_employees.where(employee_id: team_member).first_or_create!(employee_type: EMPLOYEE_TYPE[:team_member])
        end
        return self
      end
    rescue ActiveRecord::RecordInvalid => error
      self.add_errors(error)
      false
    rescue Exception
      false
    end
  end

  def add_errors(error)
    if error.record.is_a? EmployeeTeam
      if error.record.employee_id.balnk? && error.record.employee_type == EMPLOYEE_TYPE[:team_leader]
        self.errors.add(:base, I18n.t('models.team.leader_name_require'))
      end
      if error.record.employee_id.balnk? && error.record.employee_type == EMPLOYEE_TYPE[:team_member]
        self.errors.add(:base, I18n.t('models.team.team_members_require_error'))
      end
    end
  end

  def employee_lists(employee_type)
    self.employees.where(employee_teams: { employee_type: employee_type })
  end

  def self.deparment_teams(current_employee, department_id)
    current_employee.company.departments.find(department_id).teams
  end
end
