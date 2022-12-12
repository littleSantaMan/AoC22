# frozen_string_literal: true

require 'yaml'
require 'pry'

input = File.read('./input.txt')

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
      alt_map[i][j] = 96
    end
    if el == 69
      end_pos = [i, j]
      alt_map[i][j] = 123  # 97
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
end

class Point
  attr_accessor :pos, :value, :final, :refs, #, :final
                :path
                #:score, :path

  def tryy
    binding.pry
  end
  #private

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

  # def has_final?
  #   @has_final ||= if final
  #                    return true
  #                   else
  #                     refs.any? { |ref| ref.has_final? }
  #                   end
  # end

  # def min_size
  #   #binding.pry
  #   if final
  #     return 1
  #   else
  #     begin
  #       return 1 + refs.map { |ref| ref.min_size }.min
  #     rescue => exception
  #       binding.pry
  #     end
      
  #   end
  # end
end

all_points = {}
#visited = []

# # gives a new path,
# def step(path, alt_map, all_points)
#   current_pos = path.last
#   return all_points[current_pos].refs if all_points[current_pos]

#   current_val = alt_map[current_pos.first][current_pos.last]
#   current_point = Point.new
#   current_point.pos = current_pos
#   all_points[current_pos] = current_point
#  #binding.pry  if current_point.pos == [0,0]

#   if current_val == 123
#     current_point.final = true
#     return [current_point]
#   end

#   DIRS.map do |diff_v, diff_h| # --> Array<Point> # references
#     new_v = current_pos.first + diff_v
#     new_h = current_pos.last  + diff_h
    
#     new_pos = [new_v, new_h]
#     next if path.include?(new_pos) # || all_paths.any? { |path_| path_.include? new_pos }

#     next all_points[new_pos] if all_points[new_pos]
#     next unless validate_pos(*new_pos)

#     new_val = alt_map[new_v][new_h]
#     next unless validate_val(new_val, current_val)

#     new_path = (path.dup << new_pos)
    
#     all_points[current_pos].refs += step(new_path, alt_map, all_points).compact
#     current_point
#   end
# end

# def create_point?(pos, alt_map)
#   next unless validate_pos(*pos)

#   new_val = alt_map[pos.first][pos.last]
#   next unless validate_val(new_val, current_val)
# end

#step([start_pos], alt_map, all_points)



alt_map.each_with_index do |row, i|
  row.each_with_index do |value, j|
    point = Point.new
    point.value = value
    point.pos   = [i, j]
    if value == 123
      point.final = true
      point.refs = []
    end
    all_points[[i, j]] = point
  end
end

Point::ALL_POINTS = all_points
#all_paths = []
path_costs = {}

# def resolve_refs(point, all_paths, path_costs, path = [])
#   point.step_options.each do |option|
#     next if path.include?(option)

#     path_costs[option] ||= path.size
#     if path.size <= path_costs[option]
#       path_costs[option] = path.size
#     else
#       next
#     end

#     ref_point = Point::ALL_POINTS[option]
#     if ref_point.final
#       binding.pry
#       all_paths << (path.dup << point.pos)
#       next
#     end
#     resolve_refs(ref_point,all_paths, path_costs, path.dup << point.pos)
#   end
# end

#resolve_refs(all_points[[0, 0]], all_paths, path_costs)

#all_points[[0, 0]].score = []

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