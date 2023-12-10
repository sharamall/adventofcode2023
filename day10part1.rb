file = File.open "day10in.txt"

grid = {}
start = nil
y = 0
file.each_line do |l|
  x = -1
  chars = l.chomp.split ""
  chars.each do |c|
    x += 1
    next if c == "."
    start = { x: x, y: y } if c == "S"
    grid["#{x},#{y}"] = [:n, :s, :w, :e] if c == "S"
    grid["#{x},#{y}"] = [:n, :s] if c == "|"
    grid["#{x},#{y}"] = [:n, :e] if c == "L"
    grid["#{x},#{y}"] = [:w, :e] if c == "-"
    grid["#{x},#{y}"] = [:w, :n] if c == "J"
    grid["#{x},#{y}"] = [:w, :s] if c == "7"
    grid["#{x},#{y}"] = [:e, :s] if c == "F"
  end
  y += 1
end
file.close
x = start[:x]
y = start[:y]
dir = :w if grid["#{x - 1},#{y}"].include? :e rescue dir
dir = :e if grid["#{x + 1},#{y}"].include? :w rescue dir
dir = :s if grid["#{x},#{y + 1}"].include? :n rescue dir
dir = :n if grid["#{x},#{y - 1}"].include? :s rescue dir
steps = 0
until steps > 0 && x == start[:x] && y == start[:y]
  steps += 1
  x += 1 if dir == :e
  x -= 1 if dir == :w
  y += 1 if dir == :s
  y -= 1 if dir == :n
  backwards = :n if dir == :s
  backwards = :s if dir == :n
  backwards = :w if dir == :e
  backwards = :e if dir == :w
  dir = grid["#{x},#{y}"].find { |it| it != backwards }
end
puts steps / 2