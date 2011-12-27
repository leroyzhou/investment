#encoding: UTF-8
class Bond < ActiveRecord::Base
  
  attr_accessor :compoundInterest
  attr_accessor :totalRevenue
  
  attr_accessor :tenThousandRevenue
  attr_accessor :tenThousandCompoundInterest
  
  TYPE_NATIONAL = 0
  TYPE_CORPORATE = 1
  TYPE_CONVERTIBLE = 2  
  
  def hold_years
    Lei::Utils.distance_years(self.dated_date.advance(:years => self.maturity), Time.now).round(2)
  end
  
  def revenue_years
    Lei::Utils.distance_years(self.dated_date.advance(:years => self.maturity), Time.now).to_i + 1
  end
  
  def accrued_interest
    (self.coupon/365 * accrued_days * self.par/100).round(2)
  end
  
  def accrued_days
    fixed_year = Date.today.month > self.dated_date.month ? 0 : 1
    (Date.today - Date.new(Date.today.year - fixed_year, self.dated_date.month, self.dated_date.day) + 1)
  end
  
  def detail_url
    Lei::BondParser::BOND_DETAIL_BASE + self.uri
  end
  
  def total_revenue
    tax_rate = Lei::Investment::Bond.tax_rate(self.name, self.code)
    @totalRevenue ||= (Lei::Investment::Bond.total_revenue(self.price, self.coupon, self.revenue_years,tax_rate) - accrued_interest).round(2)
  end
  
  def compound_interest
    @compoundIterest ||= (Lei::Investment.compute_compound_interest_by_revenue(self.price,self.total_revenue,self.hold_years)*100).round(2) 
  end
  
  def ten_thousand_revenue
    @tenThousandRevenue ||= (self.total_revenue*100 - Bond.commission(10000)).round(2)
  end
  
  def ten_thousand_compound_interest
    @tenThousandcompoundIterest ||= (Lei::Investment.compute_compound_interest_by_revenue(self.price*100,self.ten_thousand_revenue,self.hold_years)*100).round(2) 
  end
  
  def update_bond(bond_hash)
    self.price = bond_hash[:price]
    self.change = bond_hash[:change]
    self.change_rate = bond_hash[:change_rate]
    self.volume = bond_hash[:volume]
    self.save!
  end
  
  def self.bond_type(name)
    if name.include?("国债")
      TYPE_NATIONAL
    elsif name.include?("转债")
      TYPE_CONVERTIBLE
    else
      TYPE_CORPORATE
    end
  end
  
  def self.commission(fund)
    comm = fund * 2/10000 * 2
    comm > 1 ? comm : 1
  end
  
  def self.load_all_bond
    bonds = Bond.all
    yield(bonds)
  end
  
  def self.save_bond(bond_hash)
    bond = Bond.where(:code => bond_hash[:code]).first
    if bond.blank?      
      bond = create_bond(bond_hash)
    else
      bond.update_bond(bond_hash)
    end
    bond
  end   
  
  def self.create_bond(bond_hash)
    detail = Lei::BondParser.bond_detail(bond_hash[:uri])
    bond_hash.merge!(detail)
    bond_hash[:bond_type] = bond_type(bond_hash[:name])
    self.create!(bond_hash)
  end  
  
  def self.update_bonds
    bonds = Lei::BondParser.quote
    bonds.each do |bond|
#      begin
        Bond.save_bond(bond)
#      rescue
#        logger.error "update bond error : #{bond[:code]}"
#      end
    end      
  end
  
end
