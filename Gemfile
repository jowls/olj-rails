source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby' #, '~> 3.0.0'

gem 'devise'
gem 'pg' #Postgres adapter
gem 'rabl' #Used to build API
gem 'oj' #JSON parser. Used for rabl
gem 'pushmeup' #Used for GCM push notifications
#gem 'whenever' #Cron scheduling
gem 'capistrano', '~> 3.0.1'
gem 'net-ssh' #, '~> 2.8.1', :git => 'https://github.com/net-ssh/net-ssh' #Need 2.8.1 or greater to fix issue with ssh

# rails specific capistrano funcitons
gem 'capistrano-rails', '~> 1.1.0'

# integrate bundler with capistrano
gem 'capistrano-bundler'

# if you are using RBENV
gem 'capistrano-rbenv', '~> 2.0'

# scheduling gcm pushes
gem 'rufus-scheduler'
gem 'tzinfo'
gem 'tzinfo-data'
group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'sqlite3'
end
