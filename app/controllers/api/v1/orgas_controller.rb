class Api::V1::OrgasController < Api::V1::BaseController


  def create_member
    if Orga.exists?(params[:id])

      begin
        current_api_v1_user.create_user_and_add_to_orga(
            orga: Orga.find(params[:id]),
            forename: user_params[:forename],
            surname: user_params[:surname],
            email: user_params[:email]
        )

        head status: :created

      rescue CanCan::AccessDenied
        head status: :unauthorized
      rescue ActiveRecord::RecordInvalid
        head status: :unprocessable_entity
      end

    else
      head status: :not_found
    end
  end


  def add_member

  end

  private

  def user_params
    params.require(:user).permit(:forename, :surname, :email)
  end
end