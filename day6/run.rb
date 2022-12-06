# frozen_string_literal: true

input = File.read('./input.txt')

chars = input.scan(/./)

# @param [Array<String>] chars An array of chars, f.e. ['a','d','g','a',...]
# @param [Integer] uniq The number of unique consequtive letters to find
# return [Integer] The index of the first letter that is unique the +uniq+th time.
def index(chars, uniq)
  chars.size.times do |i|
    return i + 1 if chars[i - (uniq - 1)..i].uniq.size == uniq
  end
end

# PART 1
puts index(chars, 4)

# PART 2
puts index(chars, 14)
