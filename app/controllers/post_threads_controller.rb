class PostThreadsController < ApplicationController
  # GET /post_threads
  # GET /post_threads.xml
  def index
    if forum = Forum.find_by_name(params[:forum_id])
      redirect_to forum, :status => :moved_permanently
    else
      redirect_to '/', :status => 302
    end
  end

  # GET /post_threads/1
  # GET /post_threads/1.xml
  def show
    @post_thread = PostThread.find(params[:id])
    puts request.env.inspect

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post_thread }
    end
  end

  # GET /post_threads/new
  # GET /post_threads/new.xml
  def new
    @post_thread = PostThread.new
    @post_thread.forum = Forum.find_by_name(params[:forum_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post_thread }
    end
  end

  # GET /post_threads/1/edit
  def edit
    @post_thread = PostThread.find(params[:id])
  end

  # POST /post_threads
  # POST /post_threads.xml
  def create
    @post_thread = PostThread.new(params[:post_thread])
    @post_thread.forum = Forum.find_by_name(params[:forum_id])

    respond_to do |format|
      if @post_thread.save
        flash[:notice] = 'PostThread was successfully created.'
        format.html { redirect_to(@post_thread) }
        format.xml  { render :xml => @post_thread, :status => :created, :location => @post_thread }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post_thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /post_threads/1
  # PUT /post_threads/1.xml
  def update
    @post_thread = PostThread.find(params[:id])

    respond_to do |format|
      if @post_thread.update_attributes(params[:post_thread])
        flash[:notice] = 'PostThread was successfully updated.'
        format.html { redirect_to(@post_thread) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post_thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /post_threads/1
  # DELETE /post_threads/1.xml
  def destroy
    @post_thread = PostThread.find(params[:id])
    @post_thread.destroy

    respond_to do |format|
      format.html { redirect_to(post_threads_url) }
      format.xml  { head :ok }
    end
  end
end
