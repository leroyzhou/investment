module Lei
  module Utils
    
    def self.distance_years(begin_date,end_date=Date.today)
      amend_day = 0
      (begin_date.year..end_date.year).each do |y|
        amend_day += 1 if is_leap_year?(y)
      end
      ((distance_days(begin_date,end_date) - amend_day)/365).to_f
    end
    
    def self.distance_days(begin_date,end_date=Date.today)
      begin_date = begin_date.to_date if !begin_date.is_a?(Date)
      end_date = end_date.to_date if !end_date.is_a?(Date)
      
      (end_date - begin_date).abs - 1
    end
    
    
    def self.is_leap_year?(year)
      (year%4 == 0 && year%100 != 0) || (year%400 == 0)
    end
    
  end
end