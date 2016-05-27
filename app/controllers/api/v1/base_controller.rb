class Api::V1::BaseController < ApplicationController

  respond_to :json

  before_action :ensure_host
  before_action :ensure_protocol
  before_action :authenticate
  before_action :ensure_admin_secret, only: :test_airbrake

  def ping
    render json: { pong: Time.now }
  end

  def test_airbrake
    raise Api::V1::TestAirbrakeException.new('api request for testing airbrake triggered')
  end

  private

  def ensure_host
    if (host = request.host).in?(allowed_hosts = Settings.api.hosts)
      true
    else
      render text: "wrong host: #{host}, allowed: #{allowed_hosts.join(', ')}", status: 401
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

  def authenticate
    if Settings.api.allow_token_as_param && token = params[:token]
      if token == Settings.api.token
        true
      else
        render text: 'auth failed', status: 401
        false
      end
    else
      authenticate_or_request_with_http_token do |token, _options|
        token == Settings.api.token
      end
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
