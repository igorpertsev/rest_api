source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.7'

gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'puma', '~> 5.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'mongoid', '~> 7.0.5'
gem 'grape-entity'
gem 'grape'
gem 'grape_on_rails_routes'
gem 'devise'
gem 'jwt'
gem 'simple_command'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-swagger-entity', '~> 0.3'
gem 'grape-swagger-representable', '~> 0.2'
gem 'rack-cors'
gem 'mongoid_rails_migrations'

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'


group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do 
  gem 'factory_bot_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end