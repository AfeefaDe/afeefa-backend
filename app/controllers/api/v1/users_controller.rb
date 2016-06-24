class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def list_orgas
    if current_api_v1_user == @user
      orgas = Role.where(user: @user).map(&:orga)
      render json: serialize(orgas)
    else
      head status: :forbidden
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
end
