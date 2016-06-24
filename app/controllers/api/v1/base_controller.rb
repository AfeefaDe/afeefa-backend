class Api::V1::BaseController < ApplicationController

  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  before_action :ensure_host
  before_action :ensure_protocol
  before_action :authenticate_api_v1_user!, except: %i(ping)
  before_action :ensure_admin_secret, only: %i(test_airbrake)

  private

  def ensure_host
    if (host = request.host).in?(allowed_hosts = Settings.api.hosts)
      true
    else
      render(
          text: "wrong host: #{host}, allowed: #{allowed_hosts.join(', ')}",
          status: 401
      )
      false
    end
  end

  def ensure_protocol
    if (protocol = request.protocol.gsub(/:.*/, '')).in?(allowed_protocols = Settings.api.protocols)
      true
    else
      render(
          text: "wrong protocol: #{protocol}, allowed: #{allowed_protocols.join(', ')}",
          status: 401
      )
      false
    end
  end

  def ensure_admin_secret
    if params[:admin_secret] == Settings.api.admin_secret
      true
    else
      head status: 403
      false
    end
  end

end
