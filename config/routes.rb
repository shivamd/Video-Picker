require 'api_constraints'

Videopicker::Application.routes.draw do

  devise_for :users
  root :to => 'home#index'

  namespace :api do
    #default should always be last.
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      namespace :search do
        get "youtube"
        get "vimeo"
        get "dailymotion"
        get "popular_vines"
        get "recent_vines"
        get "qwiki"
        get "instagram"
        get "videos"
      end
    end
  end

  resources :applications, only: [:new, :index, :create]

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
