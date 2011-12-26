module Lei
  module Utils
    
    def self.distance_years(date1,date2)
      fixed_day = 0
      (date2.year..date1.year).each do |y|
        fixed_day += 1 if is_leap_year?(y)
      end
      (((date1 - date2)/(3600*24) - fixed_day)/365)    
    end
    
    
    def self.is_leap_year?(year)
      (year%4 == 0 && year%100 != 0) || (year%400 == 0)
    end
    
  end
end