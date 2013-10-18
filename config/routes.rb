Videopicker::Application.routes.draw do

  root :to => 'home#index'

  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
