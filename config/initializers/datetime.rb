Time::DATE_FORMATS[:date] = "%a %b %d, %Y"
Time::DATE_FORMATS[:tiny_date] = "%m/%d/%y"
Time::DATE_FORMATS[:time] = "%I:%M%p"
Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a %b %d, %Y %l:%M%p") }