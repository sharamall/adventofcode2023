file = File.open "day13in.txt"

patterns = []
cur_pattern = []
file.each_line do |l|
  if l.chomp.empty?
    patterns << cur_pattern
    cur_pattern = []
  else
    cur_pattern.push l.chomp
  end
end
patterns << cur_pattern
sum = 0
patterns.each_with_index do |p|
  columns = p.length
  smudge = nil
  (1..(columns - 1)).each do |i|
    mismatches = []
    (1..i).reverse_each do |column|
      next if p[i - column].nil? || p[i + column - 1].nil?
      if p[i - column] != p[i + column - 1]
        mismatch = { bottom: i - column, top: i + column - 1, indexes: [], index: i }
        p[i - column].split("").each_with_index do |c, char_index|
          mismatch[:indexes].push(char_index) if c != p[mismatch[:top]][char_index]
        end
        mismatches.push mismatch
      end
    end
    smudge = mismatches[0][:index] if mismatches.length == 1 && mismatches[0][:indexes].length == 1
  end
  if smudge.nil?
    p = p.collect { |it| it.split("") }.transpose.map { |it| it.join("") }
    columns = p.length
    (1..(columns - 1)).each do |i|
      mismatches = []
      (1..i).reverse_each do |column|
        next if p[i - column].nil? || p[i + column - 1].nil?
        if p[i - column] != p[i + column - 1]
          mismatch = { bottom: i - column, top: i + column - 1, indexes: [], index: i }
          p[i - column].split("").each_with_index do |c, char_index|
            mismatch[:indexes].push(char_index) if c != p[mismatch[:top]][char_index]
          end
          mismatches.push mismatch
        end
      end
      smudge = mismatches[0][:index] if mismatches.length == 1 && mismatches[0][:indexes].length == 1
    end
    sum += smudge
  else
    sum += 100 * smudge
  end
end
puts sum