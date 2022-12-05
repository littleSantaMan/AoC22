# frozen_string_literal: true

input = File.read('./input.txt')

arrangements, movements = input.split("\n\n")

arrangements = arrangements.split("\n")[0..-2].map do |arrangement|
  (arrangement + ' ').scan(/..../).map do |letter|
    letter.match(/[A-Z]/).to_s
  end
end

arrangements = arrangements.transpose.map do |col|
  col.reject { |el| el == '' }.reverse
end

movements = movements.split("\n").map do |movement|
  match = movement.match(/move (?<nr>.*) from (?<from>.*) to (?<to>.*)/)
  {
    nr: match[:nr].to_i,
    from: match[:from].to_i - 1,
    to: match[:to].to_i - 1
  }
end

# PART 1 CODE (PART1 and PART2 code can not be run at the same time, since the 'arrangements' object
# is 'mutated' by both parts)

# movements.each do |movement|
#   movement[:nr].times do
#     arrangements[movement[:to]] << arrangements[movement[:from]].pop
#   end
# end

# result = arrangements.map(&:last).join

# # PART 1
# puts result

# PART 2 code

movements.each do |movement|
  to_move = arrangements[movement[:from]][-(movement[:nr])..]
  arrangements[movement[:from]] = arrangements[movement[:from]][0..-(movement[:nr] + 1)]
  arrangements[movement[:to]] += to_move
end

result = arrangements.map(&:last).join

# PART 2
puts result
