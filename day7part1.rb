file = File.open "day7in.txt"

# 1 high card
# 2 one pair
# 3 two pair
# 4 three of a kind
# 5 full house (bob saget)
# 6 four of a kind
# 7 five of a kind

hands = []

file.each_line do |l|
  (hand, bid) = l.chomp.split(" ").then { |it| [it[0].split(""), it[1].to_i] }
  counts = {}
  hand.each do |card|
    counts[card] = 0 if counts[card].nil?
    counts[card] += 1
  end
  if counts.length == 1
    hands << { hand: hand, score: 7, bid: bid  }
  elsif counts.length == 2
    if [1, 4].include?(counts.first[1])
      hands << { hand: hand, score: 6, bid: bid }
    else
      hands << { hand: hand, score: 5, bid: bid }
    end
  elsif counts.length == 3
    if counts.any? { |k, v| v == 3 }
      hands << { hand: hand, score: 4, bid: bid }
    else
      hands << { hand: hand, score: 3, bid: bid }
    end
  elsif counts.length == 4
    hands << { hand: hand, score: 2, bid: bid }
  else
    hands << { hand: hand, score: 1, bid: bid }
  end
end
file.close
hands.sort! do |a, b|
  next a[:score] <=> b[:score] if a[:score] != b[:score]
  score = 0
  a[:hand].each_with_index do |card, i|
    next if b[:hand][i] == card
    ranks = %w[A K Q J T 9 8 7 6 5 4 3 2 1]
    a_score = ranks.find_index card
    b_score = ranks.find_index b[:hand][i]
    score = b_score <=> a_score
    break
  end
  score
end

sum = 0
hands.each_with_index { |hand, i| sum += hand[:bid] * (i + 1) }
puts sum