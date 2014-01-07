# encoding: utf-8

require 'rubygems'
require 'redis'
require 'byebug'

@days = [31,28,31,30,31,30,31,31,30,31,30,31]
@redis = Redis.new(port: 7755)

# calc jan hours
def calc_jan_hours
  tmp = []
  24.times { tmp << 0}
  (1..31).each do |day|
    (0..23).each do |hour|
      hdata = @redis.hgetall "2013-1-#{day}-#{hour}"
      hdata.each { |k,v| tmp[hour] += v.to_i }
    end
  end
  byebug
  tmp.each { |v| @redis.rpush "2013-1_hours", v }
end

// calc jan langs hours
def calc_jan_langs

end
# @redis.hincrby "2013", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}-#{day}", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}-#{day}-#{hour}", event["repository"]["language"], size
# @redis.hincrby "2013_push", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}_push", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}-#{day}_push", event["repository"]["language"], size
# @redis.hincrby "2013-#{month}-#{day}-#{hour}_push", event["repository"]["language"], size
