file = File.open "day12in.txt"

def valid?(str, groups)
  damaged_groups = str.split(".").reject(&:empty?)
  matches = damaged_groups.length == groups.length
  damaged_groups.each_with_index do |elem, i|
    break unless matches
    matches &= elem.length == groups[i] rescue false
  end
  matches
end

rows = []
file.each_line do |l|
  (springs, groups) = l.chomp.split(" ")
  springs = [springs, springs, springs, springs, springs].join("?")
  groups = [groups, groups, groups, groups, groups].join(",")
  rows.push({ springs: springs.split(""), groups: groups.split(",").map(&:to_i), spring: springs })
  rows.push({ springs: (springs + "?").split("") , groups: groups.split(",").map(&:to_i), spring: springs })
end

sum = 0
rows.each do |row|
  (springs, groups) = [row[:springs], row[:groups]]
  bangs = []
  springs.each_with_index do |s, i|
    bangs.push i if s == "?"
  end

  row_matches = 0
  str = row[:spring]
  str.gsub!("?", "0")
  (2 ** bangs.length).times do |i|
    puts "checking #{i}"
    row_matches += 1 if valid?(str.gsub("0", ".").gsub("1", "#"), groups)
    str = str.gsub("1", "9").succ
  end
  sum += row_matches
end
puts sum
