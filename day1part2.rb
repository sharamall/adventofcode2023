file = File.open "day1in.txt"
sum = 0

file.each_line do |l|
  first_digit = nil
  last_digit = nil
  l.then do |line|
    line.gsub! "one", "one1one"
    line.gsub! "two", "two2two"
    line.gsub! "three", "three3three"
    line.gsub! "four", "four4four"
    line.gsub! "five", "five5five"
    line.gsub! "six", "six6six"
    line.gsub! "seven", "seven7seven"
    line.gsub! "eight", "eight8eight"
    line.gsub! "nine", "nine9nine"
    line.split ""
  end.each do |c|
    if c.match? /[[:digit:]]/
      first_digit = c if first_digit == nil
      last_digit = c
    end
  end
  sum += "#{first_digit}#{last_digit}".to_i
end
file.close
puts sum