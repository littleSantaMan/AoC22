# frozen_string_literal: true

input = File.read('./input.txt')

rounds = input.split("\n").map do |row|
  row.split(' ')
end

COMBS = {
  ['A', 'X'] => 4,
  ['A', 'Y'] => 8,
  ['A', 'Z'] => 3,
  ['B', 'X'] => 1,
  ['B', 'Y'] => 5,
  ['B', 'Z'] => 9,
  ['C', 'X'] => 7,
  ['C', 'Y'] => 2,
  ['C', 'Z'] => 6
}

scores = rounds.map do |row|
  COMBS[row]
end

puts scores.sum
