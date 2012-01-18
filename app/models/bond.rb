#encoding: UTF-8
class Bond < ActiveRecord::Base
  
  attr_accessor :compoundInterest
  attr_accessor :totalRevenue
  
  attr_accessor :tenThousandRevenue
  attr_accessor :tenThousandCompoundInterest
  
  TYPE_NATIONAL = 0
  TYPE_CORPORATE = 1
  TYPE_CONVERTIBLE = 2
  
  MARKET_HU = Lei::Investment::Bond::Parser::MARKET_HU
  MARKET_SHEN = Lei::Investment::Bond::Parser::MARKET_SHEN
  
  include Lei::Investment::Bond::Common  
  
  def detail_url
    Lei::Investment::Bond::Parser::BOND_DETAIL_BASE + self.uri
  end
  
  def rate_of_compound_interest
    return 0 if self.full_price > (total_revenue+self.par)
    srevenue = (Lei::Investment.rate_of_compound_interest(self.full_price,total_revenue,hold_years)*100).round(2)
    crevenue = (Lei::Investment.rate_of_compound_interest(self.full_price,compound_revenue,hold_years)*100).round(2)
    @compoundInterest ||= [srevenue,crevenue]
  end  
  
  def update_bond(bond_hash)
    self.price = bond_hash[:price]
    self.change = bond_hash[:change]
    self.change_rate = bond_hash[:change_rate]
    self.volume = bond_hash[:volume]
    self.save!
  end
  
  def self.updated_time
    bond = Bond.order("updated_at desc").first
    bond ? bond.updated_at : nil
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
    comm = fund * 2/10000
    comm > 2 ? comm * 2 : 4
  end
  
  def self.load_bond(bond_code)
    bond = self.where(:code => bond_code).first
    if bond.blank?
      #TODO
    end
    bond
  end
  
  def self.load_all_bond(options)
    bonds = if options.blank?
              Bond.all
            else
              conditions = {}
              conditions[:bond_type] = options[:type] if options[:type]
              Bond.where(conditions).all
            end
    
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
     begin
      detail = Lei::Investment::Bond::Parser.bond_detail(bond_hash[:code],bond_hash[:market])
      bond_hash.merge!(detail)
    rescue
    end  
    bond_hash[:bond_type] = bond_type(bond_hash[:name])
    self.create!(bond_hash)
  end  
  
  def self.update_bonds(refetch = false)
    if refetch
      puts "refetch all bonds, delete all"
      Bond.delete_all
    end
    bonds = Lei::Investment::Bond::Parser.quote
    bonds.each do |bond|
#      begin
        Bond.save_bond(bond)
#      rescue
#        logger.error "update bond error : #{bond[:code]}"
#      end
    end      
  end
  
end
