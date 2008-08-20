module PageObjectsHelper

  def dual_datetime_html(time1, time2, timezone = 'UTC')
    if time1.nil? && time2.nil?
      ''
    elsif time2.nil?
      "<div class=\"datetime-box\">" + datetime_html(time1, timezone) + "</div>"
    elsif time1.nil?
        "<div class=\"datetime-box\">" + datetime_html(time2, timezone) + "</div>"
    elsif same_day(time1, time2, timezone)
      "<div class=\"datetime-box\">" + datetime_range_html(time1, time2, timezone) + "</div>"
    else
      "<div class=\"dualtime-box\"><div class=\"dualtime\">" + datetime_html(time1, timezone, "first-box") + "<div class=\"time-split\">-</div>" + datetime_html(time2, timezone, "second-box") + "</div></div>"
    end
  end
  
  # Displays a single date, with a time, converted to the timezone requested
  def datetime_html(time1, timezone = 'UTC', add_class = nil, force_year = false)
    time1 = time1.in_time_zone(timezone)
    time_now = Time.now.in_time_zone(timezone)
    year_str = force_year || time1.year != time_now.year ? " <span class=\"year\">#{time1.year}</span>" : nil
    month_classname = year_str ? "month-year" : "month"
    hours = time1.strftime('%I').to_i
    box_add_classname = add_class ? " #{add_class}" : ''
    "<div class=\"datetime#{box_add_classname}\"><div class=\"#{month_classname}\">#{time1.strftime('%b.')}#{year_str}</div><div class=\"date\">#{time1.day}</div><div class=\"time\"><span class=\"time-part\">#{hours}#{time1.strftime(':%M %p')}</span></div></div>"
  end
  
  # Displays a single date, but with a timerange on it
  def datetime_range_html(time1, time2, timezone = 'UTC', force_year = false)
    time1 = time1.in_time_zone(timezone)
    time2 = time2.in_time_zone(timezone)
    time_now = Time.now.in_time_zone(timezone)
    year_str = force_year || time1.year != time_now.year ? "<span class=\"year\">#{time1.year}</span>" : nil
    month_classname = year_str ? "month-year" : "month"
    hours = time1.strftime('%I').to_i
    hours2 = time2.strftime('%I').to_i
    "<div class=\"datetime\"><div class=\"#{month_classname}\">#{time1.strftime('%b.')}</div><div class=\"date\">#{time1.day}</div><div class=\"time time-range\"><span class=\"time-part\">#{hours}#{time1.strftime(':%M %p')}</span> - <span class=\"time-part\">#{hours2}#{time2.strftime(':%M %p')}</span></div></div>"
  end
  
  def same_day(time1, time2, timezone = 'UTC')
    time1 = time1.in_time_zone(timezone)
    time2 = time2.in_time_zone(timezone)
    time1.day == time2.day && time1.month == time2.month && time1.year == time2.year
  end
  
  
end
