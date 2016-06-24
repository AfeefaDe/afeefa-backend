class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def jsonapi_model_class
    User
  end

  def list_orgas
    @jsonapi_record = Role.where(user: @user).map(&:orga)
    render json: @jsonapi_record.map(&:to_jsonapi_hash)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
