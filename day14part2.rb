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
y -= 1
cache = {}
big = 0
until big > 1000000000
  grid_clone = grid.inspect
  if cache[grid_clone].nil? || cache[grid_clone] == big - 1
    4.times do |t|
      any_moved = true
      while any_moved
        any_moved = false
        y_enumerator = (0..y).each unless t == 2
        y_enumerator = (0..y).reverse_each if t == 2
        x_enumerator = (0..x).each if t == 1
        x_enumerator = (0..x).reverse_each unless t == 1
        y_enumerator.each do |v|
          x_enumerator.each do |h|
            if grid["#{h},#{v}"] == "O"
              key = "#{h},#{v}"
              key = "#{h},#{v - 1}" if t == 0 && v > 0
              key = "#{h - 1},#{v}" if t == 1 && h > 0
              key = "#{h},#{v + 1}" if t == 2 && v < y
              key = "#{h + 1},#{v}" if t == 3 && h < x
              if grid[key].nil?
                grid[key] = grid.delete "#{h},#{v}"
                any_moved = true
              end
            end
          end
        end
      end

    end
    cache[grid_clone] = big if cache[grid_clone].nil?
  else
    cached = cache[grid_clone]
    big = 1000000000 - (1000000000 - cached) % (big - cached)
    cache.clear
  end
  big += 1
end
sum = 0

(0..y).each do |v|
  (0..x).each do |h|
    if grid["#{h},#{v}"] == "O"
      sum += (y + 1) - v
    end
  end
end
puts sum