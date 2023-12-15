file = File.open "day15in.txt"

sum = 0
file.each_line do |l|
  l.chomp.split(",").each do |word|
    score = 0
    word.split("").each do |c|
      score += c.ord
      score *= 17
      score %= 256
    end
    sum += score
  end
end
file.close
puts sum
