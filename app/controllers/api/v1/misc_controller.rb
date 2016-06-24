class Api::V1::MiscController < Api::V1::BaseController

  def ping
    render json: { pong: Time.current.to_s }
  end

  def test_airbrake
    raise Api::TestAirbrakeException.new('api request for testing airbrake triggered')
  end

end
