file = File.open "day4in.txt"
sum = 0

file.each_line do |l|
  items = l.chomp.split ":"
  (wins, picks) = items[1].chomp.then { |item| item.split "|" }.collect { |it| it.strip.split(" ").collect { |a| a.to_i } }
  score = 0
  picks.each do |pick|
    score *= 2 if score > 0 && wins.include?(pick)
    score = 1 if score == 0 && wins.include?(pick)
  end
  sum += score
end
file.close
puts sum
