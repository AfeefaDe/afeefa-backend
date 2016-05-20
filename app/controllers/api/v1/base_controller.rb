class Api::V1::BaseController < ApplicationController

  respond_to :json

  before_action :authenticate

  def ping
    render json: { pong: Time.now }
  end

  private

  def authenticate
    if Settings.api.allow_token_as_param && token = params[:token]
      if token == Settings.api.token
        true
      else
        head status: 401
        false
      end
    else
      authenticate_or_request_with_http_token do |token, _options|
        token == Settings.api.token
      end
    end
  end

end
