
module Tasks
  
  class Bonds
    
    def update_bonds
      bonds = Lei::BondParser.parse_quote_from_url
      bonds.each do |bond|
        Bond.save_bond(bond)
      end      
    end
    
  end
  
end