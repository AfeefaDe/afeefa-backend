class Api::V1::UsersController < Api::V1::BaseController

  before_action :set_user, only: [:list_orgas]

  def list_orgas
    orgas = Array.new
    roles = Role.where(user: @user).find_each do |role|
      orga = {:title => Orga.find(role.orga_id).title}
      orgas.push({ :type => 'orgas', :id => role.orga_id.to_s, :attributes => orga})
    end
    json = { :data => orgas}.to_json
    render json: json
  end

  def set_user
    @user = User.find(params[:id])
  end
end
