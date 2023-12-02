file = File.open "day2in.txt"
sum = 0
max_r = 12
max_g = 13
max_b = 14

file.each_line do |l|
  items = l.chomp.split ":"
  id = /Game (\d+)/.match(items[0]).captures[0].to_i
  vals = items[1].chomp.then { |item| item.split ";" }.map { |erm| erm.strip }
  aware = false
  vals.each do |inst|

    rolls = inst.split ','
    rolls.each do |roll|

      content = /(\d+) (.*)/.match roll
      amount = content.captures[0].to_i
      colour = content.captures[1]
      aware = true if colour == "blue" && amount > max_b
      aware = true if colour == "red" && amount > max_r
      aware = true if colour == "green" && amount > max_g
    end
  end
  sum += id unless aware
end
file.close
puts sum
