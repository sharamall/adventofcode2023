file = File.open "day4in.txt"
sum = 0
cards = {}
file.each_line do |l|
  items = l.chomp.split ":"
  id = /Card\s+(\d+)/.match(items[0]).captures[0].to_i
  (wins, picks) = items[1].chomp.then { |item| item.split "|" }.collect { |it| it.strip.split(" ").collect { |a| a.to_i } }
  score = 0
  picks.each { |pick| score += 1 if wins.include?(pick) }
  copies = cards[id] || 1
  score.times do |i|
    index = id + i + 1
    cards[index] = cards[index] + 1 * copies unless cards[index] == nil
    cards[index] = 1 + 1 * copies if cards[index] == nil
  end
  cards[id] = copies
  sum += copies
end
file.close
puts sum