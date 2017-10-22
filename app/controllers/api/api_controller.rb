class Api::ApiController < ActionController::Base
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
end 