#encoding: UTF-8
module Lei
  module Investment
    module Bond
      module Common
        
        TAX_RATE = 0.2
        
        def full_price
         (self.price + accrued_interest).round(2)
        end
        
        def hold_years
          Lei::Utils.distance_years(Date.today,self.dated_date.advance(:years => self.maturity)).round(2)
        end
        
        def total_revenue(selling_price=100)
         (selling_price - self.price + hold_interest).round(2)
        end
        
        def compound_revenue(selling_price=100)
          iys = interest_years
          rate = self.coupon * (1-tax_rate)
          cinterest = if iys == 1
                        hold_interest
                      else
                        total = 0
                        total = Lei::Investment.compound_interest_with_principal(year_interest-accrued_interest, rate, iys-1)
                        if iys-2 > 0
                         (0..iys-2).each do |y|
                            total += Lei::Investment.compound_interest_with_principal(year_interest, rate, y)
                          end
                        end
                        total
                      end
          (selling_price - self.price + cinterest).round(2)
          
        end
        
        def year_interest
         (100*self.coupon*(1-tax_rate)).round(2)
        end
        
        def interest_years
          interest_years = hold_years.to_i + 1
        end
        
        def hold_interest        
         (((self.coupon) * interest_years * self.par - accrued_interest)* (1-tax_rate)).round(2)        
        end
        
        def accrued_days
          amend_year = Date.today.month > self.dated_date.month ? 0 : 1
          Lei::Utils.distance_days(Date.new(Date.today.year - amend_year, self.dated_date.month, self.dated_date.day)) + 1
        end
        
        def accrued_interest
         ((self.coupon)/365 * accrued_days * self.par).round(2)
        end
        
        def tax_rate    
          self.name.include?("国债") ? 0 : TAX_RATE
        end
        
        def coupon_percent
          (self.coupon*100).round(2)
        end
        
      end
    end
  end
end