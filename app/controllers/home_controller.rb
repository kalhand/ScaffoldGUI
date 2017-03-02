class HomeController < ApplicationController
  layout 'home'
  def index
  #   ActiveRecord::Base.remove_connection
  end

  def sign_in
    session[:user] = params['email'] if params['email']
    redirect_to '/display'
  end  
end
