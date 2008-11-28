require 'chronic'

class PageObject < ActiveRecord::Base  
  alias_method :original_to_xml, :to_xml
  include ThriveSmartObjectMethods
  
  attr_accessor :starts, :ends
  
  before_validation :parse_dates
  
  validates_presence_of :starts, :on => :update
  
  def validate
    if starts && ends && starts_datetime > ends_datetime
      errors.add(:ends, " must be after starting time")
    end
  end
  
  def starts
    @starts ||= starts_datetime && time_zone ? starts_datetime.in_time_zone(time_zone) : starts_datetime
  end
  
  def ends
    @ends ||= ends_datetime && time_zone ? ends_datetime.in_time_zone(time_zone) : ends_datetime
  end
  
  protected
    def parse_dates
      logger.debug "PARSING DATES!--------- // STARTS : #{starts.inspect} // ENDS : #{ends.inspect}"
      old_timezone = Time.zone
      Time.zone = time_zone
      Chronic.time_class = Time.zone
      self.starts_datetime = Chronic.parse(starts)
      self.ends_datetime = Chronic.parse(ends)
      Time.zone = old_timezone
      logger.debug "FINISHED PARSING DATES!--------- // STARTS : #{starts_datetime.inspect} // ENDS : #{ends_datetime.inspect}"
    end
end
