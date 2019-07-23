class Employee < ActiveRecord::Base
  ADMIN_ROLE = 'Admin'.freeze
  belongs_to :company, :inverse_of => :employees
  belongs_to :department
  has_many :employee_teams
  has_many :teams, through: :employee_teams, dependent: :destroy
  scope :active_members, -> { where(active: true) }
  sequenceid :company, :employees
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { minimum: 5, maximum: 50 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { scope: :company_id } 
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :role, presence: true
  accepts_nested_attributes_for :company
  has_many :tasks, :as => :assignable


  def with_company
    build_company if company.nil?
    self
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
