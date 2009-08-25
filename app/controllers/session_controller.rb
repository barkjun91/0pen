class SessionController < ApplicationController
  def index
    if request.put?
      p = Person.find_by_email(params[:email])
      if p && p.password == params[:password]
        self.person = p
      else
        flash[:login_error] = p ? :password : :email
      end
    elsif request.delete?
      self.person = nil
    end
    redirect_to :back, :status => :found
  end
end
