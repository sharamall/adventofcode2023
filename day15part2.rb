file = File.open "day15in.txt"

boxes = {}
256.times do |i|
  boxes[i] = {}
end
file.each_line do |l|
  l.chomp.split(",").each do |word|
    score = 0
    last = ""
    word.split("").each do |c|
      last = c
      break if c == "=" || c == "-"
      score += c.ord
      score *= 17
      score %= 256
    end
    if last == "="
      lens = word[-1].to_i
      boxes[score][word.split("=")[0]] = lens
    else
      boxes[score].delete(word.split("-")[0])
    end
  end
end
file.close
sum = 0
256.times do |i|
  unless boxes[i].empty?
    index = 1
    boxes[i].each do |kv|
      sum += (i + 1) * (index) * kv[1]
      index += 1
    end
  end
end
puts sum