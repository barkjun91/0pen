class RedirectionsController < ApplicationController
  def index
    redirect_to params[:to]
  end
end
