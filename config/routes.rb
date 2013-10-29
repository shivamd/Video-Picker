Videopicker::Application.routes.draw do

  root :to => 'home#index'

  namespace :api do 
    namespace :v1 do
      namespace :search do
        get "youtube"
        get "vimeo"
        get "dailymotion"
        get "popular_vines"
        get "recent_vines"
        get "qwiki"
      end
    end
  end

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
