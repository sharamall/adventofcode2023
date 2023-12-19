file = File.open "day16in.txt"

grid = {}
y = -1
x = 0
max_x = x
max_y = y
file.each_line do |l|
  y += 1
  x = 0
  l.chomp.split("").each do |c|
    grid["#{x},#{y}"] = c
    x += 1
  end
  max_x = x - 1
end
max_y = y
file.close
laser_i = 0
lasers = { "#{laser_i}": {
  x: 0,
  y: 0,
  dir: :right
} }
touched_places = {}
until lasers.empty?
  to_add = []
  to_remove = []
  lasers.each do |kv|
    x = kv[1][:x]
    y = kv[1][:y]
    dir = kv[1][:dir]
    if x < 0 || x > max_x || y < 0 || y > max_y
      to_remove.push kv[0]
      next
    end
    cur = grid["#{x},#{y}"]

    touched_places["#{x},#{y}".to_sym] = [] if touched_places["#{x},#{y}".to_sym].nil?
    if touched_places["#{x},#{y}".to_sym].include?(dir) # we've already been on this tile in this direction
      to_remove.push kv[0]
    else
      touched_places["#{x},#{y}".to_sym].push(dir)
    end

    if dir == :right && cur == "\\"
      dir = :down
    elsif dir == :right && cur == "/"
      dir = :up
    elsif dir == :left && cur == "\\"
      dir = :up
    elsif dir == :left && cur == "/"
      dir = :down
    elsif dir == :down && cur == "\\"
      dir = :right
    elsif dir == :down && cur == "/"
      dir = :left
    elsif dir == :up && cur == "\\"
      dir = :left
    elsif dir == :up && cur == "/"
      dir = :right
    end
    if [:right, :left].include?(dir) && cur == "|"
      laser_i += 1
      to_add.push(["#{laser_i}".to_sym, { x: x, y: y - 1, dir: :up }])
      y += 1
      dir = :down
    elsif [:up, :down].include?(dir) && cur == "-"
      laser_i += 1
      to_add.push(["#{laser_i}".to_sym, { x: x - 1, y: y, dir: :left }])
      x += 1
      dir = :right
    else
      x += 1 if dir == :right
      x -= 1 if dir == :left
      y += 1 if dir == :down
      y -= 1 if dir == :up
    end
    kv[1][:x] = x
    kv[1][:y] = y
    kv[1][:dir] = dir
  end
  to_add.each { |it| lasers[it[0]] = it[1] }
  to_remove.each { |it| lasers.delete it }
end
puts touched_places.length
