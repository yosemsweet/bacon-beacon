source 'https://rubygems.org'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem "therubyracer"
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0'
  gem "asset_sync"
	gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
end

gem "haml", '~>4'
gem 'jquery-rails'
gem 'twitter-bootstrap-rails', '~>2'
gem "fog"

gem 'activeadmin'
gem 'omniauth'
gem "meta_search",    '>= 1.1.0.pre'

gem 'high_voltage'

group :development, :test do
  gem 'spork', '~> 0.9'
  gem "factory_girl_rails", :require => false
  gem "rspec-rails"
  gem "foreman"
  gem "timecop"
  gem "growl"
  unless ENV["CI"]
    gem 'debugger'
  end
	gem 'thin'
end

group :test do
  gem "capybara"
  gem "database_cleaner"
	gem "no_peeping_toms", "~> 2"
  gem "pickle"
  gem "bourne"
  gem "timecop"
  gem "shoulda-matchers"
  gem "email_spec"
  gem "poltergeist"
  gem "vcr"
	gem "excon"
end

group :production do
	gem 'unicorn'
end
