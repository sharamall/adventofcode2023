file = File.open "day3in.txt"
y = 0
numbers = []
symbols = {}
file.each_line do |l|
  x = 0
  cur_num = nil
  l.then { |line| line.chomp.split "" }.each do |c|
    x += 1
    if c.match? /[[:digit:]]/
      if cur_num == nil
        cur_num = { val: c.to_i, x: x, y: y, length: 1 }
        numbers.push cur_num
      else
        cur_num[:val] = cur_num[:val] * 10 + c.to_i
        cur_num[:length] += 1
      end
    else
      cur_num = nil
      symbols["#{x},#{y}"] = { val: c, neighbours: [] } unless c == "."
    end
  end
  y += 1
end
file.close
numbers.each do |num|
  x = num[:x] - 1
  y = num[:y] - 1
  3.times do |y_offset|
    (num[:length] + 2).times do |x_offset|
      adj_sym = symbols["#{x + x_offset},#{y + y_offset}"]
      adj_sym[:neighbours].push num if adj_sym != nil && adj_sym[:val] == "*"
    end
  end
end
sum = symbols.inject(0) do |sum, entry|
  symbol = entry[1]
  sum += symbol[:neighbours][0][:val] * symbol[:neighbours][1][:val] if symbol[:neighbours].length == 2
  sum
end
puts sum
