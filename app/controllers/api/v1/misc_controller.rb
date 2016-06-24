class Api::V1::MiscController < Api::V1::BaseController

  def ping
    render json: JSONAPI::Serializer.serialize(Ping.new, is_collection: false)
  end

  def test_airbrake
    raise Api::TestAirbrakeException.new('api request for testing airbrake triggered')
  end

end
