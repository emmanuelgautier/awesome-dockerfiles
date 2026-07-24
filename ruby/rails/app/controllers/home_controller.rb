class HomeController < ApplicationController
  def index
    render json: { message: "Welcome to Rails!" }
  end
end
