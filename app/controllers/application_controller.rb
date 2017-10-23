class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_locale

  STATUS = 'status'
  MESSAGE = 'message'
  POINT = 'point'
  DATA = 'data'
  CONFIG = 'config'
  STATUS_OK = 200
  STATUS_BAD_REQUEST = 400
  STATUS_NOT_FOUND = 404
  STATUS_UNAUTHORIZED = 401
  STATUS_INTERNAL_SERVER_ERROR = 500
  HTTP_API_TOKEN = 'HTTP_API_TOKEN'
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale] || 'en'
  end
end
