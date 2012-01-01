class ToolController < ApplicationController
  
  def bond_revenue
    
    @v[:left_nav_section] = 'tool_bond_revenue'
    
    @v[:code] = params[:code]
    
    return if request.get?
    
    @v[:quatity] = params[:quatity].blank? ? nil : params[:quatity].to_i
    
    @v[:fund] = params[:fund].blank? ? nil : params[:fund].to_i
    
    @v[:price] = params[:price].blank? ? nil : params[:price].to_f
    
    return if @v[:code].blank? || (@v[:fund].blank? && @v[:quatity].blank?)
    
    @v[:bond] = Bond.load_bond(@v[:code])
    
    if !@v[:price].blank?
      @v[:bond].price = @v[:price]
    end
    
    bond = @v[:bond]
        
    if @v[:fund]
      @v[:quatity] = buy_quatity(@v[:fund],bond.full_price)
    end
    
    @v[:real_fund] = (@v[:quatity] * bond.full_price + Bond.commission(@v[:quatity] * bond.full_price)).round(2)
    
    @v[:revenue] = (@v[:quatity] * bond.total_revenue).round(2)
    
  end
  
  #return_on_investment
  def roi
    @v[:left_nav_section] = 'tool_roi'
    
    @v[:capital] = params[:capital].blank? ? nil : params[:capital].to_i
    @v[:years] = params[:years].blank? ? nil : params[:years].to_i
    @v[:rate] = params[:rate].blank? ? nil : params[:rate].to_f
    @v[:schedule] = params[:schedule]
    
    return unless [@v[:rate],@v[:years],@v[:capital]].all?
    
    case @v[:schedule]
    when 'once'      
      @v[:compound_total] = Lei::Investment.compound_interest_with_principal(@v[:capital],@v[:rate]/100,@v[:years])
      @v[:simple_total] = Lei::Investment.simple_interest_with_principal(@v[:capital],@v[:rate]/100,@v[:years])
      @v[:capital_total] = @v[:capital]
    when 'month'
    else
      r = Lei::Investment.scheduled_investment(@v[:capital],@v[:rate]/100,@v[:years])
      @v[:simple_total] = r[:si]
      @v[:compound_total] = r[:ci]
      @v[:capital_total] = @v[:capital] * @v[:years]
    end
    
    
    
  end
  
  private
  def buy_quatity(fund,price)
    ((fund/price)/10).to_i * 10
  end
  
end