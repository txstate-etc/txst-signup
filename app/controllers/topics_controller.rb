require 'ri_cal'

class TopicsController < ApplicationController
  before_filter :authenticate, :except => [ :download, :show, :index, :alpha, :by_department, :by_site, :upcoming, :grid ]
  
  def alpha
    @page_title = t(:'topics.index.title')
    render :layout => 'topic_collection'
  end

  def by_department
    @page_title = t(:'topics.index.title')
    render :layout => 'topic_collection'
  end

  def by_site
    @page_title = t(:'topics.index.title')
    render :layout => 'topic_collection'
  end

  def index
    @page_title = t(:'topics.index.title')
    render :layout => 'topic_collection'
  end

  def upcoming
    # not used anymore, but we don't want to break any links/bookmarks
    redirect_to root_url, :status => 301
  end

  def grid
    @page_title = t(:'topics.index.title')    
    @cur_month = begin Date.new(params[:year].to_i, params[:month].to_i) rescue Date.today.beginning_of_month end
    render :layout => 'topic_collection'
  end

  def manage
    redirect_to topics_path and return unless authorized?

    @upcoming = session[:topics] != 'all'
    @all_depts = current_user.admin? && session[:departments] == 'all'

    # Editors: show topics for their departments only. 
    # Admins: show topics for their departments by default. Show all depts based on filter
    # Instructors: show departments for topics that they are instructors of plus any in
    @topics = Hash.new { |h,k| h[k] = SortedSet.new }
    if current_user.admin? && (@all_depts || !current_user.editor?)
      _topics = @upcoming ? Topic.upcoming : Topic.active
      _topics.each do |topic|
        @topics[topic.department] << topic
      end
      Department.active.each do |d|
        @topics[d] ||= []
      end
    elsif current_user.editor?
      _topics = @upcoming ? current_user.upcoming_topics : current_user.active_topics
      _topics.each do |topic|
        @topics[topic.department] << topic
      end      
      current_user.departments.each do |d|
        @topics[d] ||= []
      end
    end
    
    if current_user.instructor?
      # Add topics for which the current user is the instructor
      current_user.active_sessions.each do |session|
        @topics[session.topic.department] ||= []
        @topics[session.topic.department] << session.topic if !@upcoming || session.in_future?
      end
    end
    
    @page_title = "Manage Topics"
    render :layout => 'application'
  end

  def manage_topic
    begin
      @topic = Topic.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      render(:file => 'shared/404.erb', :status => 404, :layout => true) unless @topic
      return
    end

    if authorized?(@topic) || current_user.instructor?(@topic)
      @page_title = "Topic History: " + @topic.name
    else
      redirect_to topics_path
    end
  end

  def filter
    logger.debug "FILTER: #{params[:filter].join(',')}"
    # filter is an array of key value pairs, should be able to convert it to a hash
    filters = Hash[*params[:filter]]
    
    # sanitize the input to make sure we weren't passed anything bogus
    session[:topics] = case filters['topics']
      when 'upcoming' then 'upcoming'
      else 'all'
    end if filters.key?('topics')
    session[:departments] = case filters['departments']
      when 'user' then 'user'
      else 'all'
    end if filters.key?('departments')
    
    redirect_to manage_topics_path
  end
  
  def show    
    begin
      @topic = Topic.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      render(:file => 'shared/404.erb', :status => 404, :layout => true) unless @topic
      return
    end
    
    @page_title = @topic.name
      
    respond_to do |format|
      format.html
      format.atom
      if authorized? @topic
        format.csv do
          send_csv @topic.to_csv, @topic.to_param 
        end
      end
    end
  end
  
  def new
    @topic = Topic.new
    if authorized? @topic
      @page_title = "Create New Topic"
    else
      redirect_to topics_path
    end
  end

  def edit
    begin
      @topic = Topic.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      render(:file => 'shared/404.erb', :status => 404, :layout => true) unless @topic
      return
    end

    if authorized? @topic
      @page_title = "Update Topic Details"
    else
      redirect_to @topic
    end
  end
  
  # This doesn't actually do the delete action (destroy does that)
  # It just display a confirmation/warning page here with a link to the destroy action
  def delete
    begin
      @topic = Topic.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      render(:file => 'shared/404.erb', :status => 404, :layout => true) unless @topic
      return
    end

    if authorized? @topic
      @page_title = @topic.name
    else
      redirect_to @topic
    end
  end
  
  def create
    @topic = Topic.new( params[ :topic ] )
    if authorized? @topic
      if @topic.save
        flash[ :notice ] = "Topic \"" + @topic.name + "\" added."
        redirect_to @topic
      else
        @page_title = "Create New Topic"
        render :action => 'new'
      end
    else
      redirect_to topics_path
    end
  end
  
  def update
    @topic = Topic.find( params[ :id ] )
    if authorized? @topic
      success = @topic.update_attributes( params[ :topic ] )
      @page_title = @topic.name
      if success
        flash[ :notice ] = "The topic's data has been updated."
        redirect_to @topic
      else
        flash.now[ :error ] = "There were problems updating this topic."
        render :action => 'show'
      end
    else
      redirect_to @topic
    end
  end
  
  def destroy
    topic = Topic.find( params[ :id ] )
    if authorized? topic
      if topic.deactivate!
        flash[ :notice ] = "The topic \"#{topic.name}\" has been deleted."
        redirect_to manage_topics_path
        return
      else
        errors = topic.errors.full_messages.join(" ")
        flash[ :error ] = "Unable to delete topic \"#{topic.name}\". " + errors
      end
    end
    redirect_to topic
  end
    
  def download
    topic = Topic.find( params[ :id ] )
    key = fragment_cache_key(["#{date_slug}/topics/download", topic])
    data = Rails.cache.fetch(key) do 
      Cashier.store_fragment(key, topic.cache_key)
      calendar = RiCal.Calendar
      calendar.add_x_property 'X-WR-CALNAME', topic.name
      topic.upcoming_sessions.each do |session|
        session.to_event.each { |event| calendar.add_subcomponent( event ) }
      end
      calendar.export
    end
    send_data(data, :type => 'text/calendar')
  end

  def survey_results
    @topic = Topic.find( params[ :id ] )
    if authorized? @topic
      @page_title = @topic.name
    else
      redirect_to topics_path
    end
  end
  
end
