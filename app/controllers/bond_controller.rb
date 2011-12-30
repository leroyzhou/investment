class BondController < ApplicationController
  
  def index
    @v[:left_nav_section] = 'bond_all'
    load_bonds({})
  end
  
  def national
    load_bonds({:type => Bond::TYPE_NATIONAL})
    @v[:left_nav_section] = 'bond_national'
    render(:template => "/bond/index")
  end
  
  def corporate
    load_bonds({:type => Bond::TYPE_CORPORATE})
    @v[:left_nav_section] = 'bond_corporate'
    render(:template => "/bond/index")
  end
  
  def convertible
    load_bonds({:type => Bond::TYPE_CONVERTIBLE})
    @v[:left_nav_section] = 'bond_convertible'
    render(:template => "/bond/index")
  end
  
  private
  def load_bonds(options)
    @bonds = Bond.load_all_bond(options) do |bonds|
      bonds.sort{|a,b| b.rate_of_compound_interest[0]<=>a.rate_of_compound_interest[0]}
    end
  end
  
end