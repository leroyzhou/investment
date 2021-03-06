#encoding: UTF-8
require 'mathn'

module Lei
  module Investment
    
    #F=P*(1+i)^n
    def self.compound_interest_with_principal(fund,rate,years)
      (fund*((1+rate)**years)).round(2)
    end
    
    
    def self.compound_interest(fund, rate , years)
      compound_interest_with_principal(fund,rate,years) - fund
    end 
    
    def self.simple_interest_with_principal(fund, rate, years)
      fund + simple_interest(fund, rate, years)
    end 
    
    def self.simple_interest(fund, rate, years)
      fund*rate*years
    end
    
    def self.scheduled_investment(fund,interest,years)
      compound_total = 0
      simple_total = 0
       (1..years).each do |y|
        compound_total += compound_interest_with_principal(fund,interest,y)
        simple_total += simple_interest_with_principal(fund,interest,y)
      end 
      {:ci => compound_total.round(2), :si=>simple_total.round(2)}
    end
    
    #M=P(1+i)[-1+(1+i)^n]/i
    def self.scheduled_investment_month(fund,year_interest,month)
      mi = year_interest/12
      fund*(1+mi)*((1+mi)**month-1)/mi
    end
    
    
    def self.rate_of_compound_interest(fund,interest,years)  
      Math.exp(Math.log((interest+fund)/fund)/years)-1  
    end 
    
  end
end

if __FILE__ == $0
  # TODO Generated stub
end