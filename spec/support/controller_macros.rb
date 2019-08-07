module ControllerMacros
  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:employee]
    user = FactoryGirl.create(:employee)
    sign_in user
  end
end