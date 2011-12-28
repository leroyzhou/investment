class BondController < ApplicationController
  
  def index
    #bond = Lei::BondParser.bond
    return render(:text => '1')
  end
    
  def interest
    
    options = {}
    options[:type] = params[:type] if params[:type]
    
    @bonds = Bond.load_all_bond(options) do |bonds|
      bonds.sort{|a,b| b.compound_interest<=>a.compound_interest}
    end
  end
  
end