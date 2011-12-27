#encoding: UTF-8
require 'mathn'

module Lei
  module Investment
    
    module Bond
      
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
     
      def year_interest
        100*self.coupon/100*(1-tax_rate)
      end
      
      def hold_interest
        interest_years = hold_years.to_i + 1
        ((self.coupon/100) * interest_years * self.par * (1-tax_rate) - accrued_interest).round(2)
        
      end
      
      def accrued_days
        amend_year = Date.today.month > self.dated_date.month ? 0 : 1
        Lei::Utils.distance_days(Date.new(Date.today.year - amend_year, self.dated_date.month, self.dated_date.day)) + 1
      end
      
      def accrued_interest
        ((self.coupon/100)/365 * accrued_days * self.par).round(2)
      end
      
      def tax_rate    
        self.name.include?("国债") ? 0 : TAX_RATE
      end
      
    end
    
    #F=P*(1+i)^n
    def self.compound_interest(fund, interest , years)
      fund*((1+interest)**years)
    end 
    
    def self.simple_interest(fund, interest, years)
      fund + fund*interest*years
    end 
    
    def self.scheduled_investment(fund,interest,years)
      compound_total = 0
      simple_total = 0
       (1..years).each do |y|
        compound_total += compound_interest(fund,interest,y)
        simple_total += simple_interest(fund,interest,y)
      end 
      {:ci => compound_total, :si=>simple_total}
    end
    
    #M=P(1+i)[-1+(1+i)^n]/i
    def self.scheduled_investment_month(fund,year_interest,month)
      mi = year_interest/12
      fund*(1+mi)*((1+mi)**month-1)/mi
    end
    
    
    def self.compute_compound_interest_by_revenue(fund,revenue,years)  
      Math.exp(Math.log((revenue+fund)/fund)/years)-1  
    end 
    
  end
end

if __FILE__ == $0
  # TODO Generated stub
end