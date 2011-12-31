class ToolController < ApplicationController
  
  def bond_revenue
    
    @v[:left_nav_section] = 'tool_bond_revenue'
    
    @v[:code] = params[:code]
    
    return if request.get?
    
    @v[:quatity] = params[:quatity].blank? ? nil : params[:quatity].to_i
    
    @v[:fund] = params[:fund].blank? ? nil : params[:fund].to_i
    
    return if @v[:code].blank? || (@v[:fund].blank? && @v[:quatity].blank?)
    
    @v[:bond] = bond = Bond.load_bond(@v[:code])
    
    if @v[:fund]
      @v[:quatity] = buy_quatity(@v[:fund],bond.full_price)
    end
    
    @v[:real_fund] = (@v[:quatity] * bond.full_price + Bond.commission(@v[:quatity] * bond.full_price)).round(2)
    
    @v[:revenue] = @v[:quatity] * bond.total_revenue
    
  end
  
  def compound_interest
    
  end
  
  private
  def buy_quatity(fund,price)
    ((fund/price)/10).to_i * 10
  end
  
end