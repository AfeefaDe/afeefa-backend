class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def list_orgas
    orgas = Role.where(user: @user).map(&:orga)
    render json: serialize(orgas, is_collection: true)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
