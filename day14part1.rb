file = File.open "day14in.txt"

grid = {}
y = 0
x = -1
file.each_line do |l|
  x = -1
  l.chomp.split("").each do |c|
    x += 1
    next if c == "."
    grid["#{x},#{y}"] = c
  end
  y += 1
end
any_moved = true
while any_moved
  any_moved = false
  (1..y).each do |v|
    (0..x).each do |h|
      if grid["#{h},#{v}"] == "O"
        if grid["#{h},#{v - 1}"].nil?
          grid["#{h},#{v - 1}"] = grid.delete "#{h},#{v}"
          any_moved = true
        end
      end
    end
  end
end
sum = 0

(0..y).each do |v|
  (0..x).each do |h|
    if grid["#{h},#{v}"] == "O"
      sum += y - v
    end
  end
end
puts sum