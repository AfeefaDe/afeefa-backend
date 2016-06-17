class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def list_orgas
    orgas = Array.new
    roles = Role.where(user: @user).find_each do |role|
      orgas.push(Orga.find(role.orga_id))
    end
    render json: orgas
  end

  def set_user
    @user = User.find(params[:id])
  end
end
