CAS_URL = 'https://login.its.txstate.edu'
LOGOUT_URL = "#{CAS_URL}/logout"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, url: CAS_URL, on_single_sign_out: Proc.new { |request|
    AuthSessionsController.action(:single_sign_out).call request.env
  }
end
