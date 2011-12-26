require 'net/http'
require 'iconv'

module Lei
  class BondParser
    BOND_QUOTE_LINK = 'http://bond.jrj.com.cn/quote/'
    BOND_DETAILS_BASE = 'http://bond.jrj.com.cn'
    
    def self.bond
      BOND_QUOTE_LINK
    end
    
    def self.parse_quote_from_url
      parse_quote(fetch_utf8_body(BOND_QUOTE_LINK))
    end
    
    def self.parse_quote_from_file(file_root)      
      File.open(file_root,'r') do |f|
        body = f.read
        return parse_quote(body)
      end      
    end
    
    def self.parse_details_from_uri(uri)
      utf8_body = fetch_utf8_body(BOND_DETAILS_BASE+uri)
      parse_bond_details(utf8_body)
    end
    
    def self.parse_details_from_file(file_root)
      File.open(file_root,'r') do |f|
        body = f.read
        return parse_bond_details(body)
      end  
    end
    
    private
    
    def self.fetch_utf8_body(url)
      res = Net::HTTP.get_response(URI.parse(url))
      convert_to_utf8(res.body)
    end    
    
    def self.parse_quote(quote_body)
      doc = Nokogiri::HTML(quote_body)
      bonds = []
      bond_elems = doc.search('table.table_jyshq2/tr')      
      bond_elems.each do |b|
        bond = {}
        next if b['class'] == 'th1'        
        children = b.children        
        bond[:name] = children.first.children.first.content        
        bond[:uri] = children.first.children.first.attributes["href"].value
        bond[:code] = children[2].children.first.content
        bond[:price] = children[4].children.first.content
        bond[:change] = children[6].children.first.content
        bond[:change_rate] = children[8].children.first.content
        bond[:volume] = children[12].children.first.content
        bonds << bond
      end
      bonds
    end
    
    def self.parse_bond_details(details_body)
      doc = Nokogiri::HTML(details_body)
      detail_elems = doc.search('table.dt2/tr')
      bond = {}
      bond[:full_name] = detail_elems.first.children[2].children.first.content
      bond[:circulation] = detail_elems[2].children[2].children.first.content
      bond[:par] = detail_elems[2].children[6].children.first.content
      bond[:term] = detail_elems[3].children[6].children.first.content
      bond[:interest] = detail_elems[4].children[2].children.first.content
      bond[:issue_date] = detail_elems[6].children[2].children.first.content.gsub(/(\s|\t|\n)/,'')
      bond[:interest_way] = detail_elems[7].children[6].children.first.content.gsub(/(\s|\t|\n)/,'')
      bond
    end
    
    def self.convert_to_utf8(body,rencode='gb2312')
      ::Iconv.conv('UTF-8//IGNORE', rencode, body + ' ')[0..-2]
    end
    
    def self.save_to_file(name,body)
      File.open(name,'w') do |f|
        f.write(body)
      end
    end
    
  end
end

if __FILE__ == $0
  require 'rubygems'
  require 'nokogiri'
  puts Lei::BondParser.parse_details_from_uri("/bonddetail/2/120604.shtml")
  #Lei::BondParser.parse_details_from_file('details.html')
end