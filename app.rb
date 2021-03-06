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
  kk = (redis.lrange "2013-#{@month}_hours", 0, -1).map{ |k| k.to_i }
  @hmax = kk.max
  @hours = (kk).to_json
  mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  @langs = (mlangs.map { |k| [k[0], k[1].to_i] }).to_json
  @langscolor = @@langscolor.to_json
  haml :month
end

get '/2013/:month/lang/:lang/?' do
  @days = [31,28,31,30,31,30,31,31,30,31,30,31]
  @month = params[:month].to_i
  @lang = params[:lang]
  redis = Redis.new(port:7755)
  kk = []
  (0..23).each do |hh|
    kk.push (redis.hget "2013-#{@month}_hour_#{hh}", @lang).to_i
  end
  @hmax = kk.max
  @hours = (kk).to_json
  mlangs = ((redis.hgetall "2013-#{@month}").sort_by { |k, v| v.to_i}).reverse
  @langs = (mlangs.map { |k| [k[0], k[1].to_i] }).to_json
  @langscolor = @@langscolor.to_json
  haml :month
end
