class Reservation < ActiveRecord::Base
  belongs_to :session
  belongs_to :user
  validates_presence_of :user_id, :session_id
  validates_uniqueness_of :user_id, :scope => [ :session_id ], :message => "This user has already registered for this session."
  validate_on_create :session_not_cancelled, :space_available, :not_in_past
  
  def session_not_cancelled
    errors.add_to_base("You cannot register for this session, as it has been cancelled.") if session.cancelled
  end
  
  def space_available
    errors.add_to_base("This class is full.") unless session.space_is_available?
  end
  
  def not_in_past
    errors.add_to_base("You cannot register for this class, as it has already occurred.") if session.time < Time.now
  end
  
end
