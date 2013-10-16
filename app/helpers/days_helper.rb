module DaysHelper
  def get_date_text(day)
    day_int = day.date.wday
    case day_int
      when 0
        day_string = 'Sun'
      when 1
        day_string = 'Mon'
      when 2
        day_string = 'Tue'
      when 3
        day_string = 'Wed'
      when 4
        day_string = 'Thr'
      when 5
        day_string = 'Fri'
      else
        day_string = 'Sat'
    end
    @date_string = day_string + ', ' + day.date.to_s
  end
end
