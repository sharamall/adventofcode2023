file = File.open "day6in.txt"
times = file.readline.chomp.split("Time:")[1].strip.split(" ").filter { |it| !it.strip.empty? }.map { |it| it.to_i }
distances = file.readline.chomp.split("Distance:")[1].strip.split(" ").filter { |it| !it.strip.empty? }.map { |it| it.to_i }
file.close
product = 1
times.each_with_index do |time, i|
  distance = distances[i]
  wins = 0
  (1..time).each do |millis|
    result = -1 * (millis) * (millis - time)
    wins += 1 if result > distance
  end
  product *= wins
end
puts product
