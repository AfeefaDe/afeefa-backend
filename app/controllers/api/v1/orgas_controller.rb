class Api::V1::OrgasController < Api::V1::BaseController

  before_action :create_member_params, only: :create_member

  def create_member

    head status: :created
  end

  def add_member

  end

  private

  def create_member_params
    params.require(:id)
    params.require(:user).permit!(:forename, :surname, :email)
  end
end