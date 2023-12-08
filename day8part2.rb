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
cur = instructions.find_all { |k, v| k.end_with? "A" }.collect { |k, v| k }
steps_before_repeat = cur.map { |_| 0 }
until steps_before_repeat.all? { |it| it > 0 }
  cur_move_index = steps % moves.length
  move = moves[cur_move_index]
  next_cur = cur.collect { |it| instructions[it][move.to_sym] }
  next_cur.each_with_index do |elem, i|
    steps_before_repeat[i] = steps + 1 if elem.end_with?("Z") && steps_before_repeat[i] == 0
  end
  steps += 1
  cur = next_cur
end
puts(steps_before_repeat.inject(1) { |product, item| product.lcm item })