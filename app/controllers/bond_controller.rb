class BondController < ApplicationController
  
  def index
    #bond = Lei::BondParser.bond
    return render(:text => '1')
  end
    
  def interest
    @bonds = Bond.load_all_bond do |bonds|
      bonds.sort{|a,b| b.compound_interest<=>a.compound_interest}
    end
  end
  
end