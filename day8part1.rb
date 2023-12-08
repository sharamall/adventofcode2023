file = File.open "day8in.txt"
moves = file.readline.chomp.split ""
file.readline
instructions = {}
file.each_line do |l|
  (left, rights) = l.chomp.split("=").collect { |it| it.strip.gsub("(", "").gsub(")", "").split(",").flatten.collect { |erm| erm.strip } }
  instructions[left[0]] = { L: rights[0], R: rights[1] }
end
file.close
steps = 0
cur = "AAA"
until cur == "ZZZ"
  move = moves[steps % moves.length]
  cur = instructions[cur][move.to_sym]
  steps += 1
end
puts steps