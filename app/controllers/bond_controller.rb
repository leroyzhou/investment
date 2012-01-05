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
  
  def update
    Bond.update_bonds
    
    return redirect_to('/bond')    
  end
  
  private
  def init_bond
    @options = {}
    @options[:sort] = params[:sort] if params[:sort]
    @options[:filter] = params[:filter] if params[:filter]
  end
  
  
  def load_bonds(options)
    @all_bonds = Bond.load_all_bond(options) do |bonds|
      if options[:sort] == 'md'
        bonds.sort{|a,b| a.maturity_date <=> b.maturity_date}
      elsif options[:sort] == 'crd'
        bonds.sort{|a,b| b.change_rate <=> a.change_rate}
      elsif options[:sort] == 'cra'
        bonds.sort{|a,b| a.change_rate <=> b.change_rate}    
      else 
        bonds.sort{|a,b| b.rate_of_compound_interest[0]<=>a.rate_of_compound_interest[0]}
      end      
    end
    
    @bond_updated_at = Bond.updated_time
    
    if options[:filter] == 'today'
      @bonds = @all_bonds.select{|a| a.updated_at.to_date == Date.today}
      @old_bonds = @all_bonds - @bonds
    else
      @bonds = @all_bonds
    end  
  end
  
end