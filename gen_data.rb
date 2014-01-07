# encoding: utf-8

require 'rubygems'
require 'open-uri'
require 'zlib'
require 'yajl'
require 'redis'
require 'byebug'
require 'logger'

@days = [31,28,31,30,31,30,31,31,30,31,30,31]
@redis = Redis.new(host: "127.0.0.1", port: 7755)
start_time = Time.now

@log = Logger.new STDOUT

threads = []

def get_data(month, day, hours)
  hours.each do |hour|
    begin
      gz = open("data/2013-#{"%02d" % month}-#{"%02d" % day}-#{hour}.json.gz")
      @log.info "2013-#{"%02d" % month}-#{"%02d" % day}-#{hour}.json.gz"
      js = Zlib::GzipReader.new(gz).read
      Yajl::Parser.parse(js) do |event|
        if event["payload"] && event["payload"]["size"]
          size = event["payload"]["size"]
        else
          size = 1
        end
        if event["repository"] && event["repository"]["language"]
          @redis.hincrby "2013", event["repository"]["language"], size
          @redis.hincrby "2013-#{month}", event["repository"]["language"], size
          @redis.hincrby "2013-#{month}-#{day}", event["repository"]["language"], size
          @redis.hincrby "2013-#{month}-#{day}-#{hour}", event["repository"]["language"], size
          if event["type"] == "PushEvent"
            @redis.hincrby "2013_push", event["repository"]["language"], size
            @redis.hincrby "2013-#{month}_push", event["repository"]["language"], size
            @redis.hincrby "2013-#{month}-#{day}_push", event["repository"]["language"], size
            @redis.hincrby "2013-#{month}-#{day}-#{hour}_push", event["repository"]["language"], size
          end
        end
      end
    rescue
    end
  end
end

(1..12).each do |month|
  (1..31).each do |day|
    if day <= @days[month-1]
      t1 =  Thread.new {get_data(month, day, 0..5)}
      t2 =  Thread.new {get_data(month, day, 6..11)}
      t3 =  Thread.new {get_data(month, day, 12..17)}
      t4 =  Thread.new {get_data(month, day, 18..23)}
      t1.join
      t2.join
      t3.join
      t4.join
    end
  end
end

end_time = Time.now
puts "Total: #{end_time - start_time}"
