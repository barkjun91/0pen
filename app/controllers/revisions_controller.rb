require 'uri'

class RevisionsController < ApplicationController
  # GET /revisions
  # GET /revisions.xml
  def index
    if post = Post.find(params[:post_id])
      redirect_to [post.forum, post.subject, post], :status => :moved_permanently
    elsif subject = Subject.find(params[:subject_id])
      redirect_to [subject.forum, subject], :status => :moved_permanently
    elsif forum = Forum.find_by_name(params[:forum_id])
      redirect_to forum, :status => :moved_permanently
    else
      redirect_to '/', :status => 302
    end
  end

  # GET /revisions/1
  # GET /revisions/1.xml
  def show
    @revision = Revision.find_revision_by_created_at(params[:id])
    redirect_to [
      url_for([@revision.forum, @revision.subject, @revision.post]),
      '#', @revision.created_at.xmlschema
    ].join
  end

  # GET /revisions/new
  # GET /revisions/new.xml
  def new
    @revision = Revision.new(:post_id => params[:post_id])

    if self.person && @revision.post.person == self.person
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @revision }
      end
    else
      redirect_to [@revision.forum, @revision.subject, @revision.post]
    end
  end

  # GET /revisions/1/edit
  def edit
    @revision = Revision.from_param(params[:id])
  end

  # POST /revisions
  # POST /revisions.xml
  def create
    @revision = Revision.new(params[:revision])
    @revision.post = Post.find(params[:post_id])
    respond_to do |format|
      if @revision.save
        flash[:notice] = 'Revision was successfully created.'
        format.html { redirect_to [@revision.forum, @revision.subject, @revision.post, @revision]  }
        format.xml  { render :xml => @revision, :status => :created, :location => @revision }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /revisions/1
  # PUT /revisions/1.xml
  def update
    @revision = Revision.from_param(params[:id])

    respond_to do |format|
      if @revision.update_attributes(params[:revision])
        flash[:notice] = 'Revision was successfully updated.'
        format.html { redirect_to(@revision) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /revisions/1
  # DELETE /revisions/1.xml
  def destroy
    @revision = Revision.find_by_created_at(params[:id])
    @revision.destroy

    respond_to do |format|
      format.html { redirect_to(revisions_url) }
      format.xml  { head :ok }
    end
  end
end
