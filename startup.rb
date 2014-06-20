require 'sinatra'
require_relative './init'
Server.run! :host => 'localhost', :port => 4567, :server => 'thin'
