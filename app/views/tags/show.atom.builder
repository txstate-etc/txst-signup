atom_feed(:root_url => tag_url(@tag)) do |feed|
  feed.title(t(:'.atom_title_prefix') + @page_title)
  updated = @topics.max { |a, b| a.upcoming_sessions[0].updated_at <=> b.upcoming_sessions[0].updated_at } rescue nil
  feed.updated(updated ? updated.upcoming_sessions[0].updated_at : Time.now)

  if @topics.size > 0
    for topic in @topics
      session = topic.upcoming_sessions[0]
      next unless session
      feed.entry(session, :published => session.time) do |entry|
        entry.title(topic.name)
        
        summary = "#{session_info(session)} — #{session.site.name}"
        
        entry.summary(summary)
        
        # FIXME: add topic description, instructor, location, etc
        #entry.content(session_info(session))
      end
    end
  else
    # FIXME: should we display anything when there are no upcoming sessions?
  end
end
