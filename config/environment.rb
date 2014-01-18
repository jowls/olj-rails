# Load the Rails application.
require File.expand_path('../application', __FILE__)

Oljournal::Application.configure do
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
      address: 'mail.onelinejournal.org',
      port: 2525, # or 25
      user_name: 'admin@onelinejournal.org',
      password: '~~~REMOVED~~~',
      authentication: 'login'
  }
end

# Initialize the Rails application.
Oljournal::Application.initialize!