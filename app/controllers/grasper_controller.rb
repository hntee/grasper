class GrasperController < ApplicationController
  def index
  end

  def grasp
    @url = params[:url]
  end
end
