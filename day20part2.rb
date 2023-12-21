file = File.open "day20in.txt"

mappings = {}
file.each_line do |l|
  (left, right) = l.chomp.split("->").map(&:strip)
  if left == "broadcaster"
    mappings[left] = { to: right.split(", ").map(&:strip), type: :broadcaster }
  elsif left.start_with? "%"
    mappings[left[1..]] = { to: right.split(", ").map(&:strip), pulse: :low, type: :flip_flop }
  elsif left.start_with? "&"
    mappings[left[1..]] = { to: right.split(", ").map(&:strip), type: :conjunction, inputs: {} }
  end
end
file.close
state = {}
mappings.each do |k, v|
  if v[:type] == :conjunction
    mappings.each do |k2, v2|
      if v2[:to].include? k
        state[k] = {} if state[k].nil?
        state[k][k2] = :low
      end
    end
  else
    if v[:type] == :flip_flop
      state[k] = :low
    end
  end
end

# def find_rx_paths_recursive(mappings, node, path)
#   path = path + ",#{node}"
#   if node == "rx"
#     puts "path: #{path}"
#   elsif mappings.include?(node)
#     mappings[node][:to].each do |it|
#       find_rx_paths_recursive(mappings, it, path) unless path.include?(it)
#       puts "recursive path: #{path},#{it}" if path.include?(it)
#     end
#   else
#     puts "bad path: #{path}"
#   end
# end
# find_rx_paths_recursive(mappings, "broadcaster", "")

rx_lows = 0
rx_highs = 0
step_count = 0
cache = {}
until rx_lows == 1
  rx_lows = 0
  step_count += 1
  cache_key = state.inspect
  if cache.include?(cache_key)
    state = cache[cache_key]
  else
    steps = [{ from: "button", destination: "broadcaster", pulse: :low }]
    until steps.empty?
      step = steps.shift
      mapping = mappings[step[:destination]]
      mapping = {} if mapping.nil?
      rx_lows += 1 if step[:pulse] == :low && step[:destination] == "rx"
      rx_highs += 1 if step[:pulse] == :high && step[:destination] == "rx"
      if mapping[:type] == :broadcaster
        mapping[:to].each do |to|
          steps.push({ from: step[:destination], destination: to, pulse: step[:pulse] })
        end
      elsif mapping[:type] == :flip_flop
        if step[:pulse] == :low
          if state[step[:destination]] == :high
            state[step[:destination]] = :low
          else
            state[step[:destination]] = :high
          end
          mapping[:to].each do |to|
            steps.push({ from: step[:destination], destination: to, pulse: state[step[:destination]] })
          end
        end
      elsif mapping[:type] == :conjunction
        from = step[:from]
        state[step[:destination]][from] = step[:pulse]
        output = :high
        output = :low if state[step[:destination]].all? { |kv| kv[1] == :high }
        mapping[:to].each do |to|
          steps.push({ from: step[:destination], destination: to, pulse: output })
        end
      else
        print ""
      end
    end
    # cache[cache_key] = eval(state.inspect) # deep cop
  end
  puts "#{step_count}: low: #{rx_lows}, high: #{rx_highs}. cache: #{cache.size}" if step_count % 10000 == 0
end
puts step_count