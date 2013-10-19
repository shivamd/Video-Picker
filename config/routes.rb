Videopicker::Application.routes.draw do

  root :to => 'home#index'

  namespace :search do
    get "youtube"
    get "vimeo"
    get "dailymotion"
    get "popular_vines"
    get "recent_vines"
  end

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
