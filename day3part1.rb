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
        cur_num = { val: c.to_i, x: x, y: y, length: 1, adj_symbol: false }
        numbers.push cur_num
      else
        cur_num[:val] = cur_num[:val] * 10 + c.to_i
        cur_num[:length] += 1
      end
    else
      cur_num = nil
      symbols["#{x},#{y}"] = { val: c } unless c == "."
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
      num[:adj_symbol] = true if symbols["#{x + x_offset},#{y + y_offset}"] != nil
    end
  end
end
sum = numbers.inject(0) do |sum, num|
  sum += num[:val] if num[:adj_symbol]
  sum
end
puts sum
