`GEM_HOME=/usr/local/rvm/gems/ruby-2.1.2`
require 'rubygems'
require 'sinatra'
require_relative './init'
Server.run! :host => 'localhost', :port => 4567, :server => 'thin'
