file = File.open "day10extra.txt"
vals = []
longest = 0
file.each_line do |l|
  hit_wall = false
  vals << l.chomp.split("")
  longest = vals.last.length if vals.last.length > longest
end
file.close
vals.each do |val|
  (longest - val.length).times { |it| val << " "}
end

vals.transpose.each do |val|
  (longest - val.length).times { |it| val << " "}
  val.each {|v| print v}
  puts ""
end
