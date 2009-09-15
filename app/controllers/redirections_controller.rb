class RedirectionsController < ApplicationController
  def index
    if params[:validation_key]
      p = Person.find_by_validation_key(params[:validation_key]).validate_email!
      p.save!
      redirect_to p
      return
    end
    redirect_to params[:to]
  end
end
