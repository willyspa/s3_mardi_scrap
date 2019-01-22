require 'bundler'
Bundler.require
require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'json'

class Scrapping

def get_townhall_mails
  townhall_mails = []
  i = 0
  page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/val-d-oise.html"))
  page.xpath('//p/a').each do |url|
    mail = get_townhall_email("http://www.annuaire-des-mairies.com/"+url['href'][1..-1])
#
    townhall_mails << { url.text.downcase => mail }

  end
end

def get_townhall_urls
  urls = []
  page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/val-d-oise.html"))
  page.xpath('//p/a').each do |url|
    urls << { url.text.downcase => "http://www.annuaire-des-mairies.com/"+url['href'][1..-1] }
  end
  return urls
end

def get_townhall_email(townhall_url)
  begin
    page = Nokogiri::HTML(open(townhall_url))
    #page.encoding = 'utf-8'
    unless page.xpath('//body').text.downcase.include?('adresse email')
      return ''
    end
    page.xpath('//td').each do |td|
      match = td.text.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i)
      if(match)
        return match[0]
      end
    end
    rescue StandardError => e
      #ça permet de continuer d'exécuter et de voir de quelle erreur s'agit-il
      #puts e.message
      #puts e.backtrace.inspect
      #puts townhall_url
      return ''
  end
  return ''
end

def big_array

towns = get_townhall_urls

a = []
i=0
towns.each do |town|
  a << { town.keys[0] => get_townhall_email(town.values[0]) }
  i += 1
  #break if i == 25
  #puts i
end

return a

end

def write_json

    File.open("db/mairie.json","w") do |f|
    f.write(JSON.pretty_generate(big_array))

end
end

def write_googledrive



end



end
