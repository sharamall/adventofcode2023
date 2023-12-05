file = File.open "day5in.txt"
seeds = []
seeds_to_soil = {}
soil_to_fert = {}
fert_to_water = {}
water_to_light = {}
light_to_temp = {}
temp_to_humidity = {}
humidity_to_location = {}
order = [seeds_to_soil, soil_to_fert, fert_to_water, water_to_light, light_to_temp, temp_to_humidity, humidity_to_location]
order_index = 0

file.each_line { |raw_line| raw_line.chomp.then do |l|
  next if l.empty? && seeds_to_soil.empty?
  if seeds.length == 0
    s = l.match /seeds: (.*)/
    seeds = s.captures[0].split(" ").map { |it| it.to_i }
  elsif l.empty?
    order_index += 1
  else
    next if l.include? ":"
    (dest, source, dist) = l.split(" ").map { |it| it.to_i }

    order[order_index][source..(source + dist - 1)] = { start: dest, range: (dest..(dest + dist - 1)) }
  end
end
}
file.close

min = nil
seeds.each do |seed|
  val = seed
  order.each do |map|
    k, v = map.find { |entry| entry[0].include? val }
    val = val - k.begin + v[:start] rescue val
  end
  min = val if min.nil? || val < min
end
puts min