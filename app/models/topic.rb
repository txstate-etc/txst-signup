class Topic < ActiveRecord::Base
  include SessionInfoObserver
  belongs_to :department
  has_many :sessions, -> { where(cancelled: false).includes([:topic, :occurrences, :site]).order('occurrences.time') }, :dependent => :destroy
  has_many :survey_responses, through: :sessions
  include SurveyAggregates
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true, :reject_if => :all_blank
  has_paper_trail
  acts_as_taggable

  scope :active, -> { where inactive: false }

  validates :name, :description, :department, presence: true
  validates :minutes, presence: true, numericality: { only_integer: true }
  validates_associated :department
  validates :survey_url, presence: { message: "must be specified to use an external survey." }, if: Proc.new{ |topic| topic.survey_type == SURVEY_EXTERNAL }
  validate :inactive_with_no_upcoming_sessions

  after_validation :delete_new_documents_on_error

  def inactive_with_no_upcoming_sessions
    errors[:base] << "You cannot delete a topic with upcoming sessions. Cancel the sessions first." if inactive? && upcoming_sessions.present?
  end

  SURVEY_NONE = 0
  SURVEY_INTERNAL = 1
  SURVEY_EXTERNAL = 2

  def self.upcoming
    Topic.joins(sessions: :occurrences).merge(Occurrence.upcoming.order(:time)).group(:name)
  end

  def delete_new_documents_on_error
    if !self.errors.empty?
      # delete any documents that were just uploaded, since they will have to be uploaded again
      documents.destroy(documents.select(&:new_record?))
    end
    true
  end

  def deactivate!
    # if this is a brand new topic (no non-cancelled sessions), just go ahead and delete it
    if sessions.unscope(where: :cancelled).count == 0
      return self.destroy!
    end
    
    self.inactive = true
    self.save!
  end

  def <=>(other)
    self.name.downcase <=> other.name.downcase
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  # Work around issue where has_many through removes includes but keeps order
  def survey_responses
    super.reorder(nil).order('created_at DESC')
  end

  # Use this when you just care if there are any upcoming sessions, but don't need the details
  # If you do need the details at some point in the current request, use upcoming_sessions.length
  # or upcoming_sessions.present? if you don't need the exact count
  def upcoming_count
    @upcoming_count ||= @upcoming_sessions.try(:length) || Session.upcoming.where(topic: self).count
  end

  def upcoming_sessions
    @upcoming_sessions ||= sessions - past_sessions
  end

  def past_sessions
    @past_sessions ||= sessions.select { |s| s.started? }
  end

  def sorted_tags
    #FIXME: can we have a default sort order?
    tags.sort { |a,b| a.name <=> b.name }
  end

  def self.to_csv(topics)
    CSV.generate do |csv|
      csv << Session::CSV_HEADER
      topics.each do |topic|
        topic.csv_rows.each { |row| csv << row }
      end
    end
  end

  def to_csv
    key = "to_csv/#{cache_key}"
    Rails.cache.fetch(key, tag: cache_key) do
      logger.debug { "in to_csv for #{name}" }
      CSV.generate do |csv|
        csv << Session::CSV_HEADER
        csv_rows.each { |row| csv << row }
      end
    end
  end
  
  def csv_rows
    key = "csv_rows/#{cache_key}"
    Rails.cache.fetch(key, tag: cache_key) do
      sessions.unscope(where: :cancelled).map { |session| session.csv_rows }.flatten(1)
    end
  end    

end
