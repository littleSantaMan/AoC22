# frozen_string_literal: true

input = File.read('./input.txt')

# Convert Input String into an array Integers, where each integer is a total sum
# of calories for a single elf
calories_per_elf = input.split("\n\n").map { |x| x.split("\n").map(&:to_i).inject(0, :+) }

# Problem 1: Top Calory:
the_answer1 = calories_per_elf.max
puts the_answer1 # 71934

# Problem 2: Top 3 Calories:
the_answer2 = calories_per_elf.sort.reverse[0..2].inject(0, :+)

puts the_answer2 # 211447
