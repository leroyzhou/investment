class BondController < ApplicationController
  
  def index    
    options = {}
    if params[:type]
      options[:type] = params[:type]
      @v[:left_nav_section] = 'bond_#{params[:type]}'
    else
      @v[:left_nav_section] = 'bond_all'
    end 
    
    @bonds = Bond.load_all_bond(options) do |bonds|
      bonds.sort{|a,b| b.rate_of_compound_interest[0]<=>a.rate_of_compound_interest[0]}
    end
  end
  
end