file = File.open "day13in.txt"

patterns = []
cur_pattern = []
file.each_line do |l|
  if l.chomp.empty?
    patterns << cur_pattern
    cur_pattern = []
  else
    cur_pattern.push l.chomp
  end
end
patterns << cur_pattern
sum = 0
patterns.each_with_index do |p|
  columns = p.length
  matched_column = nil
  (1..(columns - 1)).each do |i|
    reflect = true
    (1..i).reverse_each do |column|
      break unless reflect
      next if p[i - column].nil? || p[i + column - 1].nil?
      reflect = false if p[i - column] != p[i + column - 1]
    end
    matched_column = i if reflect
  end
  if matched_column.nil?
    p = p.collect { |it| it.split("") }.transpose.map { |it| it.join("") }
    columns = p.length
    (1..(columns - 1)).each do |i|
      reflect = true
      (1..i).reverse_each do |column|
        break unless reflect
        next if p[i - column].nil? || p[i + column - 1].nil?
        reflect = false if p[i - column] != p[i + column - 1]
      end
      matched_column = i if reflect
    end
    sum += matched_column
  else
    sum += 100 * matched_column
  end
end
puts sum