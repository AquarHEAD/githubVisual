output = File.new("down_urls.txt", "w")

days = [31,28,31,30,31,30,31,31,30,31,30,31]

(1..12).each do |month|
  (1..31).each do |day|
    if day <= days[month-1]
      (0..23).each do |hour|
        output.puts "http://data.githubarchive.org/2013-#{"%02d" % month}-#{"%02d" % day}-#{hour}.json.gz"
      end
    end
  end
end
