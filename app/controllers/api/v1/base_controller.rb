class Api::V1::BaseController < ApplicationController

  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  before_action :ensure_host
  before_action :ensure_protocol
  before_action :authenticate_api_v1_user!, except: %i(ping)
  before_action :ensure_admin_secret, only: %i(test_airbrake)

  rescue_from CanCan::AccessDenied do
    head status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do
    head status: :not_found
  end

  private

  def ensure_host
    allowed_hosts = Settings.api.hosts
    if (host = request.host).in?(allowed_hosts)
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
    allowed_protocols = Settings.api.protocols
    if (protocol = request.protocol.gsub(/:.*/, '')).in?(allowed_protocols)
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

  def serialize(model, **options)
    options[:is_collection] = model.respond_to?(:each) && !model.respond_to?(:each_pair)
    JSONAPI::Serializer.serialize(model, options)
  end

end
