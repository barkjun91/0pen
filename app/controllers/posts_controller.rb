class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    if subject = Subject.find(params[:subject_id])
      redirect_to [subject.forum, subject], :status => :moved_permanently
    elsif forum = Forum.find_by_name(params[:forum_id])
      redirect_to forum, :status => :moved_permanently
    else
      redirect_to '/', :status => 302
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new(:subject_id => params[:subject_id])
    if self.person
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @post }
      end
    else
      render :text => 'please log in', :status => 401.1
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save && self.person
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to [@post.subject.forum, @post.subject, @post] }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
