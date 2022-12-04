# frozen_string_literal: true

input = File.read('./input.txt')

# INPUT:
# 2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8
# OUTPUT:
# [[[2, 3, 4], [6, 7, 8]],
#  [[2, 3], [4, 5]],
#  [[5, 6, 7], [7, 8, 9]],
#  [[2, 3, 4, 5, 6, 7, 8], [3, 4, 5, 6, 7]],
#  [[6], [4, 5, 6]],
#  [[2, 3, 4, 5, 6], [4, 5, 6, 7, 8]]]
elf_pairs = input.split("\n").map do |row|
  row.split(',').map do |elf|
    first, last = elf.split('-')
    (first.to_i..last.to_i).to_a
  end
end

results = elf_pairs.map do |range1, range2|
  [range1, range2].include?(range1 & range2)
end

# PART1
puts results.count(true)

results2 = elf_pairs.reject do |range1, range2|
  (range1 & range2).empty?
end

# PART2
puts results2.count
