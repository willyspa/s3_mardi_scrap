require 'bundler'
Bundler.require
#require 'lib/app/scrapper.rb'
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'views/index'
require 'views/done'
#require 'views/fichier_2'

index = Index.new
index.choix

Done.new.recommencer


=begin
puts "Quel format de fichier pour les donées scrappé ?"
puts "taper 1 pour JSON"
puts "taper 2 pour google spreadsheet"
puts "taper 3 pour CSV"

user_choice = gets.chomp

if user_choice == "1"

    scrap = Scrapping.new
    scrap.save_as_json

elsif user_choice == "2"

    scrap = Scrapping.new
    scrap.save_as_spreadsheet

elsif user_choice == "3"

  scrap = Scrapping.new
  scrap.save_as_csv

else

  puts "recommencer"

end
=end
