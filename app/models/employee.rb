class Employee < ActiveRecord::Base
  scope :active_members, -> { where(active: true) }

  sequenceid :company, :employees
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { minimum: 5, maximum: 50 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { scope: :company_id },
            uniqueness: { scope: :role}, if: :role_admin?
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :role, presence: true
  belongs_to :company
  accepts_nested_attributes_for :company

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

  def role_admin?
    if role == "Admin"
      true
    else
      false
    end
  end

end
