#encoding: UTF-8
module Lei
  module Investment
    module Bond
      module Common
        
        TAX_RATE = 0.2
        
        def maturity_date
          self.dated_date.advance(:years => self.maturity)
        end
        
        def full_price
         (self.price + accrued_interest).round(2)
        end
        
        def hold_years
          Lei::Utils.distance_years(Date.today,maturity_date).round(2)
        end
        
        def total_revenue(selling_price=100)
         (selling_price - self.full_price + hold_interest).round(2)
        end
        
        def compound_revenue(selling_price=100)
          iys = interest_years
          rate = self.coupon * (1-tax_rate)
          cinterest = if iys == 1
                        hold_interest
                      else
                        total = 0
                        (0..iys-1).each do |y|
                            total += Lei::Investment.compound_interest_with_principal(year_interest, rate, y)
                        end
                        total
                      end
          (selling_price - self.price + cinterest).round(2)          
        end
        
        def year_interest
         (100*self.coupon*(1-tax_rate)).round(2)
        end
        
        def interest_years
          interest_years = (Date.today.month == maturity_date.month && Date.today.day == maturity_date.day) ? self.hold_years : self.hold_years.to_i + 1
        end
        
        def hold_interest        
         (((self.coupon) * interest_years * self.par)* (1-tax_rate)).round(2)        
        end
        
        def accrued_days
          last_interest_day = Date.new(Date.today.year,self.dated_date.month,self.dated_date.day)
          if last_interest_day > Date.today
            last_interest_day = last_interest_day.advance(:years => -1)
          end
          Lei::Utils.distance_days(last_interest_day) + 1
        rescue 
          return 0
        end
        
        def accrued_interest
         ((self.coupon)/365 * accrued_days * self.par).round(2)
        end
        
        def first_year_interest
          ((self.coupon*self.par - accrued_interest)*(1-tax_rate)).round(2)          
        end
        
        def tax_rate    
          self.name.include?("国债") ? 0 : TAX_RATE
        end
        
        def coupon_percent
          (self.coupon*100).round(2)
        end
        
        def self.is_national_band?(code,name)
          name.include?("国债")
        end
        
        def self.is_corporate_bond?(code,name)
          !(self.is_national_band?(code,name) || self.is_convertible_bond?(code,name))
        end
        
        def self.is_convertible_bond?(code,name)
          name.include?("转债")
        end
        
      end
    end
  end
end