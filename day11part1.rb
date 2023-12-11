file = File.open "day11in.txt"

galaxies = {}
x = 0
y = 0
id = 0
file.each_line do |l|
  x = 0
  l.chomp.split("").each do |c|
    galaxies["#{x},#{y}"] = { x: x, y: y, id: (id += 1) } if c == "#"
    x += 1
  end
  y += 1
end
rows_to_expand = []
columns_to_expand = []
y.times do |temp_y|
  any_galaxies = false
  x.times do |temp_x|
    any_galaxies |= galaxies.include?("#{temp_x},#{temp_y}")
  end
  rows_to_expand << temp_y unless any_galaxies
end
x.times do |temp_x|
  any_galaxies = false
  y.times do |temp_y|
    any_galaxies |= galaxies.include?("#{temp_x},#{temp_y}")
  end
  columns_to_expand << temp_x unless any_galaxies
end
new_galaxies = {}
galaxies.each do |k, v|
  expanded_x, expanded_y = [v[:x], v[:y]]
  expanded_x += columns_to_expand.find_all { |it| it < expanded_x }.length
  expanded_y += rows_to_expand.find_all { |it| it < expanded_y }.length
  new_galaxies["#{expanded_x},#{expanded_y}"] = { x: expanded_x, y: expanded_y, id: v[:id] }
end
galaxies = new_galaxies.map { |kv| kv[1] }
sum = 0

galaxies[..-2].each_with_index do |va, i|
  galaxies[(i + 1)..].each do |vb|
    dist = (va[:x] - vb[:x]).abs + (va[:y] - vb[:y]).abs
    sum += dist
  end
end
file.close
puts sum