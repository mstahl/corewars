# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

require 'polyglot'
require 'treetop'
require File.expand_path(File.dirname(__FILE__) + '/redcode')

class Instruction < Treetop::Runtime::SyntaxNode
  attr_accessor :address
  attr_accessor :labels
  
  attr_accessor :label
  attr_accessor :opcode
  attr_accessor :modifier
  attr_accessor :a_operand
  attr_accessor :a_mode
  attr_accessor :b_operand
  attr_accessor :b_mode
  
  def value
    # Handle labels here. If this line has a label, add it to @labels
    if label_list then
      labels += label_list.value
    end
    
    if field then
      # First form: label_list? operation mode? field comment
      opcode = operation.value
      a_mode = mode.value if mode
      a_operand = field.value
    else
      # Second form: label_list? operation a_operand:(mode? expr) "," b_operand:(mode? expr) comment
      
    end
  end
end

class Warrior < Treetop::Runtime::SyntaxNode
  attr_reader :instructions
  attr_reader :labels
  
  attr_reader :metadata
  
  def initialize(text)
    @instructions = []
    @labels = {}
    @metadata = {}
    
    text.lines.each_with_index do |line, line_no|
      # Compress whitespace
      line.gsub! /\s+/, ' '
      # Strip out the comments from the line
      line.gsub! /;.*/, ''
      line.strip!
      # Attempt to parse
      unless line.blank?
        instruction = Corewars.parse line
        
        if instruction then
          @instructions << instruction.value
        else
          throw "Parse error on line #{line_no + 1}: #{line}"
        end
      end
    end
    
    # Should do something with labels here....
    @instructions.each_with_index do |instruction, address|
      if instruction[:labels] then
        instruction[:labels].each do |l|
          @labels[l.to_sym] = address   # Label addresses are stored here relative to start of program
        end
      end
    end
    
    # Final pass for metadata here. Should only continue until it encounters a
    # line not beginning with ";", as a (premature) optimization.
  end
end

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

class Corewars
  # Simulation variables
  attr_reader :core
  attr_reader :config
  
  def initialize(options = {})
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
    }.merge options
    @process_queue = []     # An array of program counters

    @core = [nil] * @config[:core_size]
    
    @warriors = {}    # Hash that will hold, for each warrior, various stats about it
  end
  
  def register_warrior(warrior)
    @warriors[warrior.class.to_sym]
  end
  
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