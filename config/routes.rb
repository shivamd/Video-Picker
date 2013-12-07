require 'api_constraints'

Videopicker::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }
  root :to => 'home#index'

  namespace :api do
    #default should always be last.
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      namespace :search do
        get "videos"
      end
    end
  end

  resources :applications, only: [:new, :index, :create]

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  get "*missing" => redirect("/")
end
