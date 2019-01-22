require 'bundler'
Bundler.require
require 'lib/app/scrapper.rb'
#$:.unshift File.expand_path("./../lib", __FILE__)
#require 'scrapper.rb'

scrap = Scrapping.new
scrap.write_json
