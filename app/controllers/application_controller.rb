class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  after_action :set_access_control_headers

  def set_access_control_headers
    #todo clean up urls and remove wildcard
    if Rails.env.development?
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method']= '*'
    end
  end
end
