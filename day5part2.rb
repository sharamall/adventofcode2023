file = File.open "day5in.txt"
seeds = []
seeds_to_soil = {}
soil_to_fert = {}
fert_to_water = {}
water_to_light = {}
light_to_temp = {}
temp_to_humidity = {}
humidity_to_location = {}
order = [seeds_to_soil, soil_to_fert, fert_to_water, water_to_light, light_to_temp, temp_to_humidity, humidity_to_location]
order_index = 0

file.each_line { |raw_line| raw_line.chomp.then do |l|
  next if l.empty? && seeds_to_soil.empty?
  if seeds.length == 0
    s = l.match /seeds: (.*)/
    s.captures[0].split(" ").map { |it| it.to_i }.each_slice(2) { |seed_slice| seeds.push(seed_slice[0]..(seed_slice[0] + seed_slice[1] - 1)) }
  elsif l.empty?
    order_index += 1
  else
    next if l.include? ":"
    (dest, source, dist) = l.split(" ").map { |it| it.to_i }

    order[order_index][source..(source + dist - 1)] = { start: dest, finish: (dest + dist - 1), dist: dist }
  end
end
}
file.close
min = nil

class Range
  def overlaps?(other)
    raise "exclude_end? not implemented" if self.exclude_end? || other.exclude_end?
    other.begin <= self.end && self.begin <= other.end
  end
end

def range_overlaps(from, to)
  raise "no overlap" unless to.overlaps? from
  if from.begin < to.begin
    if from.end > to.end
      # |--------| from
      #    |---|   to
      [
        { range: (from.begin..(to.begin - 1)), overlaps: false },
        { range: to, overlaps: true },
        { range: (to.end + 1)..from.end, overlaps: false }
      ]
    elsif from.end == to.end
      # |------| from
      #    |---| to
      [
        { range: (from.begin..(to.begin - 1)), overlaps: false },
        { range: to, overlaps: true }
      ]
    else
      # |------| from
      #      |------| to
      [
        { range: (from.begin..(to.begin - 1)), overlaps: false },
        { range: (to.begin..from.end), overlaps: true }
      ]
    end
  elsif from.begin == to.begin
    if from.end > to.end
      # |--------| from
      # |---|   to
      [
        { range: to, overlaps: true },
        { range: (to.end + 1)..from.end, overlaps: false }
      ]
    elsif from.end == to.end
      # |------| from
      # |------| to
      [
        { range: to, overlaps: true }
      ]
    else
      # |------| from
      # |---------| to
      [
        { range: from, overlaps: true },
      ]
    end
  else
    if from.end < to.end
      #    |---|   from
      # |--------| to
      [
        { range: from, overlaps: true },
      ]
    elsif from.end == to.end
      #       |-----| from
      #     |-------| to
      [
        { range: from, overlaps: true }
      ]
    else
      #      |------| from
      # |------| to
      [
        { range: (from.begin..to.end), overlaps: true },
        { range: (to.end + 1)..from.end, overlaps: false }
      ]
    end
  end
end

seeds.each do |seed|
  ranges = [seed]
  order.each do |mapping|
    to_process = ranges
    processed = []

    while to_process.size > 0
      cur = to_process.pop
      anything_changed = false
      mapping.each do |k, v|
        next unless k.overlaps? cur
        anything_changed = true
        split_ranges = range_overlaps cur, k
        split_ranges.each do |r|
          if r[:overlaps]
            range_diff = v[:start] - k.begin
            new_begin = r[:range].begin + range_diff
            new_end = r[:range].end + range_diff
            processed.push(new_begin..new_end)
          else
            to_process.unshift r[:range]
          end
        end
      end
      processed << cur unless anything_changed
    end
    ranges = processed
  end
  ranges.each { |r| min = r.begin if min.nil? || r.begin < min }
end

puts min