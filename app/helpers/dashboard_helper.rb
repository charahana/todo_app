module DashboardHelper
    def completion_bar_color(rate)
      case rate
      when 0..29
        "bg-danger"
      when 30..69
        "bg-info"
      else
        "bg-success"
      end
    end
    
    def formatted_date(date)
      return "" if date.blank?
      date.strftime("%m/%d")
    end
end
