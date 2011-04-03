Time::DATE_FORMATS[:date] = "%a %b %d, %Y"
Time::DATE_FORMATS[:tiny_date] = "%m/%d/%y"
Time::DATE_FORMATS[:time] = "%l:%M%P"
Time::DATE_FORMATS[:parsetime] = "%H:%M:%S"

Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a %b %d, %Y %l:%M%P") }


Time::DATE_FORMATS[:wday] = lambda { |time| time.strftime("%a") }
Time::DATE_FORMATS[:dom] = lambda { |time| time.strftime("%e") }
Time::DATE_FORMATS[:month] = lambda { |time| time.strftime("%b") }