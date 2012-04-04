# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def friendly_time(time)
    if (time.hour == 12 && time.min == 0) 
      "Noon"
    elsif (time.hour == 0 && time.min == 0)
      "Midnight"
    else
      time.strftime('%l:%M%p')
    end  
  end
  
  def formatted_time_range(start_time, duration)
    return nil unless start_time && duration
    end_time = duration.minutes.since start_time
    start_time.strftime('%A, %B %e, %Y, ') + friendly_time(start_time) + " - " + friendly_time(end_time)
  end

  def link_to_remove_fields(name, f, options={})
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", options)
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"set_initial_#{association.to_s.singularize}_value\")"))
  end
  
  def survey_link(reservation)
    return '' if reservation.session.last_time > Time.now || 
      reservation.attended == Reservation::ATTENDANCE_MISSED || 
      reservation.survey_response.present? || 
      reservation.session.topic.survey_type == 0 ||
      current_user.nil? ||
      current_user != reservation.user
    
    if reservation.session.topic.survey_type == 1
      url = new_survey_response_url + "?reservation_id=#{reservation.id}"
    elsif reservation.session.topic.survey_type == 2
      url = reservation.session.topic.survey_url
    end
    link_to 'Take the survey!', url, :class => 'survey-link'
  end
  
end
