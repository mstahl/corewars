# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

require 'polyglot'
require 'treetop'
# require File.expand_path(File.dirname(__FILE__) + '/redcode')

Treetop.load 'redcode'

class Instruction < Treetop::Runtime::SyntaxNode
  attr_accessor :label
  attr_accessor :opcode
  attr_accessor :modifier
  attr_accessor :a_operand
  attr_accessor :a_mode
  attr_accessor :b_operand
  attr_accessor :b_mode
end

class Warrior < Treetop::Runtime::SyntaxNode
  attr_reader :instructions
  
  def initialize(text)
    @instructions = list
  end
  
  
end

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Corewars
  # Simulation variables
  attr_reader :core
  @config = {
    :core_size         => 8192,
    :cycles_before_tie => 100_000,
    :fill              => :dat,
    :size_limit        => 256,
    :thread_limit      => 64,
    :min_separation    => 512,
    :read_limit        => -1,
    :separation        => 512,
    :write_limit       => -1
  }
  
  def initialize(options)
    @config = options.merge(@config)
  end
  
  def register_warrior ; end
  
  def run ; end
  
  def step ; end
  
  # Class methods #############################################################
  
  def self.parse(text)
    parser = RedcodeParser.new
    result = parser.parse text
    unless result
      puts parser.failure_reason
      puts parser.failure_line
      puts parser.failure_column
    end
    result
  end
end