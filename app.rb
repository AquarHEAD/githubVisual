# encoding: utf-8

require 'rubygems'
require 'redis'
require 'sinatra'
require 'haml'
require 'byebug'

get '/' do
  haml :index
end

get '/2013/:month/?' do
  @days = [31,28,31,30,31,30,31,31,30,31,30,31]
  @month = params[:month].to_i
  redis = Redis.new(port:7755)
  @hours = redis.lrange "2013-#{@month}_hours", 0, -1
  @mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  haml :month
end

get '/2013/:month/lang/:lang/?' do
  @days = [31,28,31,30,31,30,31,31,30,31,30,31]
  @month = params[:month].to_i
  redis = Redis.new(port:7755)
  @hours = redis.lrange "2013-#{@month}_hours", 0, -1
  @mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  haml :month
end
