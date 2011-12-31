module BondHelper
  def hexun_bond_link(bond)
    hexun_base = 'http://bond.money.hexun.com'
    case bond.bond_type
    when Bond::TYPE_NATIONAL      
      "#{hexun_base}/treasury_bond/#{bond.code}.shtml"
    when Bond::TYPE_CORPORATE
      "#{hexun_base}/corporate_bond/#{bond.code}.shtml"
    when Bond::TYPE_CONVERTIBLE
      "#{hexun_base}/all_bond/#{bond.code}_zz.shtml"      
    end
  end
end