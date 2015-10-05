class SessionsController < Devise::SessionsController
  after_action :set_csrf_headers
  def set_csrf_headers
    response.headers['X-CSRF-Param'] = request_forgery_protection_token.to_s
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end
  respond_to :json
end
