require 'bundler'
Bundler.require
require 'nokogiri'
require 'rubygems'
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'

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

def save_as_json

    File.open("db/mairie.json","w") do |f|
    f.write(JSON.pretty_generate(big_array))
    end

end



def save_as_spreadsheet



  # Creates a session. This will prompt the credential via command line for the
  # first time and save it to config.json file for later usages.
  # See this document to learn how to create config.json:
  # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
  session = GoogleDrive::Session.from_config("config.json")

  # First worksheet of
  # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
  # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
  ws = session.spreadsheet_by_key("1rnQonRuv3981rz9SbnYofjfdQBUG5iUMo-91ne7e-mU").worksheets[0]

  # Gets content of A2 cell.
  p ws[2, 1]  #==> "hoge"

  # Changes content of cells.
  # Changes are not sent to the server until you call ws.save().

  towns = get_townhall_urls



  k=1
  towns.each do |town|

      ws[k, 1] = town.keys[0]
      ws[k, 2] = get_townhall_email(town.values[0])
      k += 1

  end

  ws.save

  # Reloads the worksheet to get changes by other clients.
  ws.reload


end


def save_as_csv

    i = 1
    towns = get_townhall_urls
		CSV.open("db/email.csv", "wb") do |f|

      towns.each do |town|

           f << [i,town.keys[0],get_townhall_email(town.values[0])]
           i += 1

      end


   end

end


end
