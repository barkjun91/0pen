class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.xml
  def index
    if forum = Forum.find_by_name(params[:forum_id])
      redirect_to forum, :status => :moved_permanently
    else
      redirect_to '/', :status => 302
    end
  end

  # GET /subjects/1
  # GET /subjects/1.xml
  def show
    @subject = Subject.find(params[:id])
    @person_log = self.person or false
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.xml
  def new
    @subject = Subject.new
    @person_log = self.person  
    @subject.forum = Forum.find_by_name(params[:forum_id])
    if self.person
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @subject }
      end
    else
      render :text => 'please log in', :status => 401.1  
    end
  end

  # GET /subjects/1/edit
  def edit
    @subject = Subject.find(params[:id])
  end

  # POST /subjects
  # POST /subjects.xml
  def create
    @subject = Subject.new(params[:subject])
    @post = Post.new(:person_id => self.person.id)
    @revision = Revision.new(params[:revision])
    @subject.forum = Forum.find_by_name(params[:forum_id])
    respond_to do |format|
      if @subject.save
        @post.subject_id = @subject.id 
        if @post.save
          @revision.post_id = @post.id 
          if @revision.save
          flash[:notice] = 'Subject was successfully created.'
          format.html { redirect_to [@subject.forum, @subject] }
          format.xml  { render :xml => @subject, :status => :created, :location => @subject }
          end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subjects/1
  # PUT /subjects/1.xml
  def update
    @subject = Subject.find(params[:id])

    respond_to do |format|
      if @subject.update_attributes(params[:subject])
        flash[:notice] = 'Subject was successfully updated.'
        format.html { redirect_to [@subject.forum, @subject] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subject.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.xml
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to(subjects_url) }
      format.xml  { head :ok }
    end
  end
end
