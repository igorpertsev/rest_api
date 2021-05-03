Rails.application.routes.draw do
  devise_for :customers
  mount API => '/'
end
