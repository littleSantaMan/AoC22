# frozen_string_literal: true

require 'yaml'
require 'pry'

input = File.read('./test_input.txt')

alt_map = input.split("\n").map do |row|
  row.scan(/./).map(&:ord)
end
SIZE_H = alt_map.first.size
SIZE_V = alt_map.size

# S = 83
# E = 69
# a - z : 97 - 122

start_pos = nil
end_pos   = nil

alt_map.each_with_index do |row, i|
  row.each_with_index do |el, j|
    if el == 83
      start_pos = [i, j]
      alt_map[i][j] = 97
    end
    if el == 69
      end_pos = [i, j]
      alt_map[i][j] = 123 # 97
    end
  end
end

DIR_W = [0,1]
DIR_N = [-1,0]
DIR_E = [0,-1]
DIR_S = [1,0]

DIRS = [DIR_W, DIR_N, DIR_E, DIR_S]

def validate_pos(new_v, new_h)
  return false unless ((new_h >= 0) && (new_h < SIZE_H))
  return false unless ((new_v >= 0) && (new_v < SIZE_V))

  true
end

def validate_val(new_val, old_val)
  return true if new_val - old_val <= 1

  false
end

class Path
  attr_reader :old_path, :last_el, :score

  def initialize(last_el, score, old_path = nil)
    @last_el = last_el
    @score = score
    @old_path = old_path
  end

  def to_a
    if old_path
      old_path.to_a + [last_el]
    else
      [last_el]
    end
  end

  def to_a_
    to_a.map { |el| el.pos }
  end

  #def find_el()
end

class Point
  attr_accessor :pos, :value, :final,
                :path

  def step_options
    @step_options ||= DIRS.map do |diff_v, diff_h| # --> Array<Point> # references
                        new_v = pos.first + diff_v
                        new_h = pos.last  + diff_h

                        new_pos = [new_v, new_h]

                        next unless validate_pos(*new_pos)

                        new_val = ALL_POINTS[new_pos].value
                        next unless validate_val(new_val, value)

                        ALL_POINTS[new_pos]
                      end.compact
  end
end

all_points = {}

alt_map.each_with_index do |row, i|
  row.each_with_index do |value, j|
    point = Point.new
    point.value = value
    point.pos   = [i, j]
    if value == 123
      point.final = true
    end
    all_points[[i, j]] = point
  end
end

Point::ALL_POINTS = all_points

def run(current_points, step)
  current_points.flat_map do |current_point|
    current_point.step_options.map do |option|
      option_path = option.path
      if option_path
        if step < option_path.score
          better_path = Path.new(option, step, current_point.path)
          option.path = better_path
          option
        end
      else
        option.path = Path.new(option, step, current_point.path)
        if option.final
          return []
        end
        option
      end
    end
  end.compact
end


step = 0
first_point = all_points[start_pos]
first_path  = Path.new(first_point, step)

first_point.path = first_path
current_points = [first_point]


while !current_points.empty?
  step += 1
  current_points = run(current_points, step)
  # current_points.each do |x|
  #   print(x.pos)
  #   puts ''
  # end
  # puts '--------'
end



#sizes = all_paths.map {|x| x.size}
#puts sizes.min

#pathy = all_points[end_pos].path.to_a_
#print pathy.size - 1
print all_points[end_pos].path.score

binding.pry


# screen = alt_map.map do |row|
#   Array.new(row.size, '|..|')
# end
# pathy.each_with_index do |step, i|
#   screen[step.first][step.last] = "|#{i.to_s.ljust(2,'..')}|"
# end
# screen.each do |row|
#   puts row.join('')
# end