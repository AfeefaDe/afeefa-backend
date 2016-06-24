class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def list_orgas
    @jsonapi_record = Role.where(user: @user).map(&:orga)
    render json: JSONAPI::Serializer.serialize(@jsonapi_record, is_collection: true)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
