# encoding: utf-8

require 'rubygems'
require 'redis'
require 'sinatra'
require 'haml'
require 'byebug'
require 'yaml'
require 'json'

@@github_langs = YAML::load_file(File.join(__dir__, 'languages.yml'))
@@langscolor = {}
@@github_langs.each { |k, v| @@langscolor[k] = v["color"] if v["color"] }

get '/' do
  haml :index
end

get '/2013/:month/?' do
  @days = [31,28,31,30,31,30,31,31,30,31,30,31]
  @month = params[:month].to_i
  redis = Redis.new(port:7755)
  @hours = redis.lrange "2013-#{@month}_hours", 0, -1
  mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  @langs = mlangs.map { |k| [k[0], k[1].to_i] }
  @langscolor = @@langscolor.to_json
  haml :month
end

get '/2013/:month/lang/:lang/?' do
  @days = [31,28,31,30,31,30,31,31,30,31,30,31]
  @month = params[:month].to_i
  redis = Redis.new(port:7755)
  @hours = redis.lrange "2013-#{@month}_hours", 0, -1
  mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  @langs = mlangs.map { |k| [k[0], k[1].to_i] }
  haml :month
end
