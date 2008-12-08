require 'chronic'

class PageObject < ActiveRecord::Base  
  alias_method :original_to_xml, :to_xml
  include ThriveSmartObjectMethods
  
  attr_accessor :starts, :ends, :starts_at, :ends_at
  
  before_validation :parse_dates
  
  validates_presence_of :starts, :on => :update
  
  def validate
    if starts_at && ends_at && starts_datetime > ends_datetime
      errors.add(:starts_at, " must be before end time")
    end
  end
  
  def starts_at
    @starts_at ||= starts_datetime && time_zone ? starts_datetime.in_time_zone(time_zone).strftime('%Y-%m-%d %H:%M') : (starts_datetime ? starts_datetime.strftime('%Y-%m-%d %H:%M') : nil)
  end
  
  def ends_at
    @ends_at ||= ends_datetime && time_zone ? ends_datetime.in_time_zone(time_zone).strftime('%Y-%m-%d %H:%M') : (ends_datetime ? ends_datetime.strftime('%Y-%m-%d %H:%M') : nil)
  end
  
  def starts
    @starts ||= starts_datetime && time_zone ? starts_datetime.in_time_zone(time_zone) : starts_datetime
  end
  
  def ends
    @ends ||= ends_datetime && time_zone ? ends_datetime.in_time_zone(time_zone) : ends_datetime
  end
  
  protected
    def parse_dates
      logger.debug "PARSING DATES!--------- // STARTS : #{starts_at.inspect} // ENDS : #{ends_at.inspect}"
      old_timezone = Time.zone
      Time.zone = time_zone
      Chronic.time_class = Time.zone
      self.starts_datetime = Chronic.parse(starts_at)
      self.ends_datetime = Chronic.parse(ends_at)
      Time.zone = old_timezone
      logger.debug "FINISHED PARSING DATES!--------- // STARTS : #{starts_datetime.inspect} // ENDS : #{ends_datetime.inspect}"
    end
end
