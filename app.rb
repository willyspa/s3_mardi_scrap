require 'bundler'
Bundler.require
#require 'lib/app/scrapper.rb'
$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'views/index'
require 'views/done'
#require 'views/fichier_2'

Index.new.choix


Done.new.recommencer
