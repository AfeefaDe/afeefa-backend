class Api::V1::MiscController < Api::V1::BaseController

  def jsonapi_model_class
    Ping
  end

  def ping
    render json: @jsonapi_record.to_jsonapi_hash
  end

  def test_airbrake
    raise Api::TestAirbrakeException.new('api request for testing airbrake triggered')
  end

end
