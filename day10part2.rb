file = File.open "day10in.txt"

grid = {}
start = nil
y = 0
max_x = 0
file.each_line do |l|
  x = -1
  chars = l.chomp.split ""
  chars.each do |c|
    x += 1
    next if c == "."
    start = { x: x, y: y } if c == "S"
    grid["#{x},#{y}"] = { dirs: [:n, :s, :w, :e], char: "S" } if c == "S"
    grid["#{x},#{y}"] = { dirs: [:n, :s], char: "|" } if c == "|"
    grid["#{x},#{y}"] = { dirs: [:n, :e], char: "└" } if c == "L"
    grid["#{x},#{y}"] = { dirs: [:w, :e], char: "-" } if c == "-"
    grid["#{x},#{y}"] = { dirs: [:w, :n], char: "┘" } if c == "J"
    grid["#{x},#{y}"] = { dirs: [:w, :s], char: "┐" } if c == "7"
    grid["#{x},#{y}"] = { dirs: [:e, :s], char: "┌" } if c == "F"
  end
  # puts(l.gsub("F", "┌").gsub("L", "└").gsub("J", "┘").gsub("7", "┐"))
  y += 1
  max_x = x + 1
end
max_y = y
file.close
x = start[:x]
y = start[:y]
dir = :w if grid["#{x - 1},#{y}"][:dirs].include? :e rescue dir
dir = :e if grid["#{x + 1},#{y}"][:dirs].include? :w rescue dir
dir = :s if grid["#{x},#{y + 1}"][:dirs].include? :n rescue dir
dir = :n if grid["#{x},#{y - 1}"][:dirs].include? :s rescue dir
steps = 0
path = { "#{x},#{y}" => grid["#{x},#{y}"] }
path["#{x},#{y}"][:char] = "↑" if dir == :n
path["#{x},#{y}"][:char] = "↓" if dir == :s
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
  dir = grid["#{x},#{y}"][:dirs].find { |it| it != backwards }
  path["#{x},#{y}"] = grid["#{x},#{y}"]
end
puts steps / 2
max_y.times do |_y|
  max_x.times do |_x|
    if path.include? "#{_x},#{_y}"
      print path["#{_x},#{_y}"][:char]
    elsif grid.include? "#{_x},#{_y}"
      print "o"
    else
      print "."
    end
  end
  puts ""
end