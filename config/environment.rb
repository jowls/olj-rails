# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Oljournal::Application.initialize!

Oljournal::Application.configure do
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      :address   => "smtp.onelinejournal.org",
      :port      => 587, # or 25
      :enable_starttls_auto => true, # detects and uses STARTTLS
      :user_name => "admin@onelinejournal.org",
      :password  => "~~~REMOVED~~~",
      :authentication => 'login'
  }
end