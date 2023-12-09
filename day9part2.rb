file = File.open "day9in.txt"
sum = 0
file.each_line do |l|
  vals = l.chomp.split(" ").collect { |it| it.to_i }
  sequences = [vals]
  until sequences.last.all? 0
    next_seq = []
    sequences.last.each_with_index do |elem, i|
      next if i == 0
      next_seq.push(sequences.last[i] - sequences.last[i - 1])
    end
    sequences.push next_seq
  end
  last_val = 0
  last_val = sequences.pop[0] - last_val until sequences.empty?
  sum += last_val
end
file.close
puts sum