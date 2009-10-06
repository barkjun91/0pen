class PeopleController < ApplicationController
  POSTS_PER_PAGE = 3.0

  # GET /people
  # GET /people.xml
  def index
    @people = Person.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find_by_param(params[:id])
    @total_pages = (@person.posts.size / POSTS_PER_PAGE).ceil
    @selected_page = [[1, params[:page].to_i].max, @total_pages].min
    @posts = @person.posts.find(
      :all,
      :offset => (@selected_page - 1) * POSTS_PER_PAGE,
      :limit => POSTS_PER_PAGE
    )
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
    @validation_ticket = ValidationTicket.find_by_key(params[:key])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find_by_param(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    prod = ENV['RAILS_ENV'] == 'production'
    validation_ticket = ValidationTicket.find_by_key(params[:key])

    if validation_ticket
      params[:person][:url] = nil if params[:person][:url].blank?
      params[:person][:email] = validation_ticket.email 
      @person = Person.new(params[:person])
      respond_to do |format|
        if (!prod || verify_recaptcha(@person)) && @person.save
          validation_ticket.destroy
          flash[:notice] = '계정이 만들어졌습니다!'
          format.html { redirect_to(@person) }
          format.xml  { render :xml => @person, :status => :created,
                               :location => @person }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @person.errors,
                               :status => :unprocessable_entity }
        end
      end
    else
      @validation_ticket = ValidationTicket.find_by_email(params[:email]) ||
                           ValidationTicket.new(:email => params[:email])
      @validation_ticket.deliver
      respond_to do |format|
        format.html
        format.xml  { render :xml => @validation_ticket, :status => :created }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find_by_param(params[:id])
    params[:person][:url] = nil if params[:person][:url].blank?

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find_by_param(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
end
