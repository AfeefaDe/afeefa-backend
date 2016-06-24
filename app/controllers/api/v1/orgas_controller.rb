class Api::V1::OrgasController < Api::V1::BaseController

  before_action :set_orga
  before_action :set_user, only: [:remove_member, :promote_member, :demote_admin]

  def create_member
    begin
      current_api_v1_user.create_user_and_add_to_orga(
          orga: Orga.find(params[:id]),
          forename: user_params[:forename],
          surname: user_params[:surname],
          email: user_params[:email]
      )
      head status: :created
    rescue CanCan::AccessDenied
      head status: :forbidden
    rescue ActiveRecord::RecordInvalid
      head status: :unprocessable_entity
    end
  end


  def add_member

  end

  def remove_member
    begin
      current_api_v1_user.remove_user_from_orga(member: @user, orga: @orga)
      head status: :ok
    rescue CanCan::AccessDenied
      head status: :forbidden
    rescue ActiveRecord::RecordNotFound
      head status: :not_found
    end
  end

  def promote_member
    begin
      current_api_v1_user.promote_member_to_admin(member: @user, orga: @orga)
      head status: :ok
    rescue CanCan::AccessDenied
      head status: :forbidden
    rescue ActiveRecord::RecordNotFound
      head status: :not_found
    end
  end

  def demote_admin
    begin
      current_api_v1_user.demote_admin_to_member(member: @user, orga: @orga)
      head status: :ok
    rescue CanCan::AccessDenied
      head status: :forbidden
    rescue ActiveRecord::RecordNotFound
      head status: :not_found
    end
  end

  def list_members
    if current_api_v1_user && current_api_v1_user.belongs_to_orga?(@orga)
      users = Role.where(orga: @orga).map(&:user)
      render json: serialize(users, is_collection: true)
    else
      head status: :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:forename, :surname, :email)
  end

  def set_orga
    if Orga.exists?(params[:id])
      @orga = Orga.find(params[:id])
    else
      head status: :not_found
    end
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
