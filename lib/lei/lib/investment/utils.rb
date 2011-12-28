#encoding: UTF-8
require 'mathn'

module Lei
  module Investment    
    
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