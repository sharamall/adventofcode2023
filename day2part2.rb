file = File.open "day2in.txt"
sum = 0

file.each_line do |l|
  items = l.chomp.split ":"
  vals = items[1].chomp.then { |item| item.split ";" }.map { |erm| erm.strip }
  max_r = 0
  max_g = 0
  max_b = 0

  vals.each do |inst|
    rolls = inst.split ','
    rolls.each do |roll|
      content = /(\d+) (.*)/.match(roll)
      amount = content.captures[0].to_i
      colour = content.captures[1]
      max_b = amount if colour == "blue" && amount > max_b
      max_r = amount if colour == "red" && amount > max_r
      max_g = amount if colour == "green" && amount > max_g
    end
  end
  sum += max_b * max_r * max_g
end
file.close
puts sum
