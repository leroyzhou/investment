#encoding: UTF-8
require 'net/http'
require 'iconv'

module Lei
  module Investment
    module Bond
      class Parser
        
        MARKET_HU = '1'
        MARKET_SHEN = '2'
        
        BOND_QUOTE_LINK = 'http://bond.money.hexun.com/quote/default.aspx?market='
        BOND_DETAIL_BASE = 'http://bond.jrj.com.cn/bonddetail/_MARKET/_BOND_CODE.shtml'
        BOND_RATE_BASE = 'http://bond.money.hexun.com/all_bond/_BOND_CODE.shtml'  
        
        def self.bond_detail_link(bond_code,market)
          BOND_DETAIL_BASE.sub(/_MARKET/,market).sub(/_BOND_CODE/,bond_code)
        end
        
        def self.quote
          hu_bonds = parse_quote(fetch_utf8_body("#{BOND_QUOTE_LINK}#{MARKET_HU}")){|b| b[:market] = MARKET_HU}
          shen_bonds = parse_quote(fetch_utf8_body("#{BOND_QUOTE_LINK}#{MARKET_SHEN}")){|b| b[:market] = MARKET_SHEN}
          
          hu_bonds + shen_bonds
        end
        
        def self.quote_by_file(file_root)      
          File.open(file_root,'r') do |f|
            body = f.read
            return parse_quote(body)
          end      
        end
        
        def self.bond_detail(bond_code, market)
          #jrj 2 is hu, 1 is shen
          market = market == '2' ? '1' : '2'
          link = bond_detail_link(bond_code, market)
          utf8_body = fetch_utf8_body(link)
          parse_bond_detail(utf8_body)
        end
        
        def self.bond_detail_by_file(file_root)
          File.open(file_root,'r') do |f|
            body = f.read
            return parse_bond_detail(body)
          end  
        end
        
        private
        
        def self.fetch_utf8_body(url)
          res = Net::HTTP.get_response(URI.parse(url))
          convert_to_utf8(res.body)
        end    
        
        def self.parse_quote(quote_body,&block)
          doc = Nokogiri::HTML(quote_body)
          bonds = []
          bond_elems = doc.search('div#BondQuote1/table/tr')            
          bond_elems[2..-2].each do |b|
            children = b.search('td')
            bond = {}
            bond[:code] = children.first.content
            bond[:name] = children[1].children.first.content.strip()
            bond[:price] = children[2].content
            bond[:change] = children[3].content
            bond[:change_rate] = children[4].children.first.content
            bond[:volume] = children[6].content
            yield(bond) if block_given?
            bonds << bond
          end
          bonds
        end
        
        def self.parse_bond_detail(detail_body)
          doc = Nokogiri::HTML(detail_body)
          detail_elems = doc.search('table.dt2/tr')
          bond = {}          
          bond[:issuer] = detail_elems.first.children[2].children.first.content
          name = detail_elems[1].children[2].content
          code = detail_elems[1].children[6].content          
          bond[:quantity] = detail_elems[2].children[2].children.first.content          
          bond[:par] = detail_elems[2].children[6].children.first.content
          bond[:maturity] = detail_elems[3].children[6].children.first.content
          pcoupon = detail_elems[4].children[2].children.first.content
          bond[:coupon] = (pcoupon.to_f/100).round(4)
          bond[:dated_date] = detail_elems[6].children[2].children.first.content.gsub(/(\s|\t|\n)/,'')
          bond[:par_frequency] = detail_elems[7].children[6].children.first.content.gsub(/(\s|\t|\n)/,'')
          
          if Bond::Common.is_corporate_bond?(code,name)
            bond[:rating] = parse_bond_rating(code)     
          end    
          bond
        end
        
        def self.parse_bond_rating(bond_code)
          body = fetch_utf8_body(BOND_RATE_BASE.sub(/_BOND_CODE/,bond_code))
          doc = Nokogiri::HTML(body)
          elems = doc.search('div.mainboxcontent/table/tr/td/table/tr/td/table/tr')
          elems[20].children[1].content
        rescue
          ""  
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
  end
end

if __FILE__ == $0
  require 'rubygems'
  require 'nokogiri'
  require '~/Workspace/investment/lib/lei/lib/investment/bond/common'
  #puts Lei::Investment::Bond::Parser.quote
  puts Lei::Investment::Bond::Parser.bond_detail('110011','2')#122897
  #puts Lei::Investment::Bond::Parser.parse_bond_rate('111044')
  #puts Lei::BondParser.parse_detail_from_file('126019')
end