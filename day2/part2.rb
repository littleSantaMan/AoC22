# frozen_string_literal: true

# rubocop: disable Style/SingleLineMethods

input = File.read('./input.txt')

rounds = input.split("\n").map do |row|
  row.split(' ')
end

class Weapon
  def self.draw; self; end
end

class Rock < Weapon
  def self.score; 1; end

  def self.win;  Paper;    end # So Paper 'wins' over Rock
  def self.lose; Scissors; end # And Scissors 'lose' over Rock
end

class Paper < Weapon
  def self.score; 2; end

  def self.win;  Scissors; end
  def self.lose; Rock;     end
end

class Scissors < Weapon
  def self.score; 3; end

  def self.win;  Rock;  end
  def self.lose; Paper; end
end

TYPE_MAP = {
  'A' => Rock,
  'B' => Paper,
  'C' => Scissors
}.freeze

STATE_MAP = {
  'X' => :lose,
  'Y' => :draw,
  'Z' => :win
}.freeze

STATE_SCORE = {
  lose: 0,
  draw: 3,
  win: 6
}.freeze

results = rounds.map do |round|
  opp_draw   = TYPE_MAP[round.first] # Rock, Paper, Scissors
  state_type = STATE_MAP[round.last] # :win, :lose, :draw
  my_draw = opp_draw.send state_type
  my_draw.score + STATE_SCORE[state_type]
end

# THE ANSWER
puts results.sum
# rubocop: enable Style/SingleLineMethods
