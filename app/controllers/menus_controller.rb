class MenusController < ApplicationController
  skip_before_action :authenticate_employee!, only: [:home]

  def index
  end

  def home
    @companies = Company.all
  end
end
