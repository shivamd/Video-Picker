class HomeController < ApplicationController

  def index
    session[:user] = "mysecuretoken"
    respond_to do |format|
      format.html
    end
  end
end
