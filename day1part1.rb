file = File.open "day1in.txt"
sum = 0

file.each_line do |l|
  first_digit = nil
  last_digit = nil
  l.then { |line| line.split "" }.each do |c|
    if c.match? /[[:digit:]]/
      if first_digit == nil
        first_digit = c
      end
      last_digit = c
    end
  end
  sum += "#{first_digit}#{last_digit}".to_i
end
file.close
puts sum