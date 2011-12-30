class BondController < ApplicationController
  
  def index
    #bond = Lei::BondParser.bond
    return render(:text => '1')
  end
    
  def interest
    
    options = {}
    options[:type] = params[:type] if params[:type]
    
    @bonds = Bond.load_all_bond(options) do |bonds|
      bonds.sort{|a,b| b.rate_of_compound_interest[0]<=>a.rate_of_compound_interest[0]}
    end
  end
  
end