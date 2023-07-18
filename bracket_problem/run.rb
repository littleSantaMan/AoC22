# frozen_string_literal: true

# This problem is being solved: https://www.hackerrank.com/challenges/balanced-brackets/problem

MAPS = {
  '}' => '{',
  ']' => '[',
  ')' => '('
}.freeze

# @param [Array<char>] brackets
# @return [Array<char>] shrinked brackets
def shrink(brackets)
  brackets.each_with_object([]) do |bracket, stack|
    next stack.pop if stack.last && MAPS[bracket] == stack.last

    stack << bracket
  end
end

# TEST!
[
  '[]',
  '[][]',
  '[[][]]',
  '][',
  '][][',
  '[]][[]',
  '{[()]}',
  '{[(])}',
  '{{[[(())]]}}'
].map(&:chars).each do |brackets|
  shrinked_brackets = shrink(brackets)
  puts "orig: #{brackets.join.ljust(15, ' ')}: shrinked: #{shrinked_brackets.join.ljust(10, ' ')} # #{shrinked_brackets.empty? ? 'OK' : 'NOT OK' }"
end
