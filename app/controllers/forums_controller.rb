class ForumsController < ApplicationController
  SUBJECTS_PER_PAGE = 15.0

  # GET /forums
  # GET /forums.xml
  def index
    @forums = Forum.find(:all)
    @posts=Post.find_order_by_created_at(:limit => SUBJECTS_PER_PAGE)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
      format.atom
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = Forum.find_by_name(params[:id])
    @total_pages = (@forum.subjects.size / SUBJECTS_PER_PAGE).ceil
    @selected_page = [[1, params[:page].to_i].max, @total_pages].min
    @subjects = @forum.subjects.find(
                  :all,
                  :offset => (@selected_page - 1) * SUBJECTS_PER_PAGE,
                  :limit => SUBJECTS_PER_PAGE
                )
    @posts = @forum.posts.find(:all, :limit => SUBJECTS_PER_PAGE)
    @person_log = self.person
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum }
      format.atom
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = Forum.new

    #if @admin
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
    #else
    # rendor :text => 'you are not admin', :status => 401.4 
    #end
  end

  # GET /forums/1/edit
  def edit
    @forum = Forum.find_by_name(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save #and admin
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to(@forum) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = Forum.find_by_name(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = 'Forum was successfully updated.'
        format.html { redirect_to(@forum) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find_by_name(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end
end
