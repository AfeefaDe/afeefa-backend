class Api::V1::OrgasController < Api::V1::BaseController

  before_action :set_orga
  before_action :set_user, only: [:remove_member, :promote_member, :demote_admin, :add_member]

  def create_member
    begin
      new_member =
          current_api_v1_user.create_user_and_add_to_orga(
              orga: Orga.find(params[:id]),
              forename: user_params[:forename],
              surname: user_params[:surname],
              email: user_params[:email]
          )
      render json: serialize(new_member)
      head status: :created
    rescue ActiveRecord::RecordInvalid
      head status: :unprocessable_entity
    end
  end


  def add_member
    @orga.add_new_member(new_member: @user, admin: current_api_v1_user)
    head status: :no_content
  end

  def remove_member
    if current_api_v1_user == @user
      current_api_v1_user.leave_orga(orga: @orga)
    else
      current_api_v1_user.remove_user_from_orga(member: @user, orga: @orga)
    end
    head status: :no_content
  end

  def promote_member
    current_api_v1_user.promote_member_to_admin(member: @user, orga: @orga)
    head status: :no_content
  end

  def demote_admin
    current_api_v1_user.demote_admin_to_member(member: @user, orga: @orga)
    head status: :no_content
  end

  def list_members
    members = @orga.list_members(member: current_api_v1_user)
    render json: serialize(members)
  end

  def update
    @orga.update_data(member: current_api_v1_user, data: orga_params[:attributes])
    render json: @orga
  end

  private

  def user_params
    params.require(:user).permit(:forename, :surname, :email)
  end

  def orga_params
    params.require(:data).permit(:id, :type, :attributes => [:title, :description, :logo])
  end

  def set_orga
    @orga = Orga.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
