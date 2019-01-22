require 'bundler'
Bundler.require
#require 'lib/app/scrapper.rb'
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
#require 'views/fichier_2'

scrap = Scrapping.new
scrap.write_json
