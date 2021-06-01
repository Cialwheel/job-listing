class WelcomeController < ApplicationController
  def index
    flash[:notice] = "zao"
  end
end
