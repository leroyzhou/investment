class BondController < ApplicationController
  
  before_filter :init_bond
  
  def index
    @v[:left_nav_section] = 'bond_all'    
    load_bonds(@options)
  end
  
  def national
    load_bonds(@options.merge({:type => Bond::TYPE_NATIONAL}))
    @v[:left_nav_section] = 'bond_national'
    render(:template => "/bond/index")
  end
  
  def corporate
    load_bonds(@options.merge({:type => Bond::TYPE_CORPORATE}))
    @v[:left_nav_section] = 'bond_corporate'
    render(:template => "/bond/index")
  end
  
  def convertible
    load_bonds(@options.merge({:type => Bond::TYPE_CONVERTIBLE}))
    @v[:left_nav_section] = 'bond_convertible'
    render(:template => "/bond/index")
  end
  
  private
  def init_bond
    @options = {}
    @options[:sort] = params[:sort] if params[:sort]
  end
  
  
  def load_bonds(options)
    @bonds = Bond.load_all_bond(options) do |bonds|
      if options[:sort] == 'md'
        bonds.sort{|a,b| a.maturity_date <=> b.maturity_date}
      else 
        bonds.sort{|a,b| b.rate_of_compound_interest[0]<=>a.rate_of_compound_interest[0]}
      end      
    end
  end
  
end