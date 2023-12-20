file = File.open "day20in.txt"

mappings = {}
file.each_line do |l|
  (left, right) = l.chomp.split("->").map(&:strip)
  if left == "broadcaster"
    mappings[left] = { to: right.split(", ").map(&:strip), type: :broadcaster }
  elsif left.start_with? "%"
    mappings[left[1..]] = { to: right.split(", ").map(&:strip), pulse: :low, type: :flip_flop }
  else
    mappings[left[1..]] = { to: right.split(", ").map(&:strip), type: :conjunction, inputs: {} }
  end
end
file.close
mappings.each do |k, v|
  if v[:type] == :conjunction
    mappings.each do |k2, v2|
      if v2[:to].include? k
        v[:inputs][k2] = :low
      end
    end
  end
end

highs = 0
lows = 0
1000.times do
  steps = [{ from: "button", destination: "broadcaster", pulse: :low }]
  until steps.empty?
    step = steps.shift
    lows += 1 if step[:pulse] == :low
    highs += 1 if step[:pulse] == :high
    mapping = mappings[step[:destination]]
    mapping = {} if mapping.nil?
    if mapping[:type] == :broadcaster
      mapping[:to].each do |to|
        steps.push({ from: step[:destination], destination: to, pulse: step[:pulse] })
      end
    elsif mapping[:type] == :flip_flop
      if step[:pulse] == :low
        if mapping[:pulse] == :high
          mapping[:pulse] = :low
        else
          mapping[:pulse] = :high
        end
        mapping[:to].each do |to|
          steps.push({ from: step[:destination], destination: to, pulse: mapping[:pulse] })
        end
      end
    elsif mapping[:type] == :conjunction
      from = step[:from]
      mapping[:inputs][from] = step[:pulse]
      output = :high
      output = :low if mapping[:inputs].all? { |kv| kv[1] == :high }
      mapping[:to].each do |to|
        steps.push({ from: step[:destination], destination: to, pulse: output })
      end
    else
      print ""
    end
  end
end
puts highs * lows