# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

require 'polyglot'
require 'treetop'

require 'corewars/redcode'
require 'pp'

class Instruction < Treetop::Runtime::SyntaxNode
  def value
    hash = {
      :opcode   => operation.value[:opcode],
      :modifier => operation.value[:modifier],
      :label    => lbl ? lbl.text_value.gsub(/\s+/, '_').gsub(/[^\w_]/, '').to_sym : nil
    }
    
    if defined? a
      if a.value.class == Hash then
        hash[:a_mode] = a.value[:mode]
        hash[:a] = a.value[:expression]
      else
        hash[:a] = a.value
      end
    end
    
    if defined? b
      if b.value.class == Hash then
        hash[:b_mode] = b.value[:mode]
        hash[:b] = b.value[:expression]
      else
        hash[:b] = b.value
      end
    end
    
    hash
  end
end

class Operation < Treetop::Runtime::SyntaxNode
  def value
    {
      :opcode   => opcode.text_value.to_sym,
      :modifier => defined? modifier ? nil : modifier.text_value.to_sym
    }
  end
end

class Operand < Treetop::Runtime::SyntaxNode
  def value
    {
      :expression => primary.value,
      :mode       => mode ? mode.text_value : nil
    }
  end
end

class Warrior
  attr_reader :instructions
  attr_reader :labels
  
  attr_reader :metadata
  
  def initialize(text)
    @instructions = []
    @labels = {}
    @metadata = {}
    
    text.lines.each_with_index do |line, line_no|
      # Check for metadata
      if line =~ /^;@(\w+)\s+(.+)/ then
        @metadata[$1.to_sym] ||= []
        @metadata[$1.to_sym] << $2
        next
      end
      # Compress whitespace
      line.gsub! /\s+/, ' '
      # Strip out the comments from the line
      line.gsub! /;.*/, ''
      line.strip!
      # Attempt to parse
      unless line.blank?
        instruction = Mars.parse(line)
        
        @instructions << instruction.value
      end
    end
    
    # Should do something with labels here....
    @instructions.each_with_index do |instruction, address|
      if instruction[:label] then
        @labels[instruction[:label].to_sym] = address   # Label addresses are stored here relative to start of program
      end
    end
    
    # The metadata are stored as an array of strings right now. They should
    # be handled here to be human-readable.
    if @metadata[:author] then
      @metadata[:author] = @metadata[:author].join(',')
    end
    if @metadata[:strategy] then
      @metadata[:strategy] = @metadata[:strategy].join(' ')
    end
    if @metadata[:name] then
      @metadata[:name] = @metadata[:name][0]
    end
  end
end

class Mars
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

    @core = [Mars.parse("dat #0, #0")] * @config[:core_size]
    
    @warriors = {}    # Hash that will hold, for each warrior, various stats about it
  end
  
  def register_warrior(warrior)
    @warriors[warrior.class.to_sym] = warrior
  end
  
  def run ; end
  
  def step
    # Each step of the simulation, the next program counter in the process queue
    # must be run. 
  end
  
  def self.parse(text)
    parser = RedcodeParser.new
    result = parser.parse text
    unless result
      err =  "#{parser.failure_reason}:\n"
      err << "'#{text}'\n"
      err << " " + (" " * parser.failure_column.to_i) + "^\n"
      throw err
    end
    result
  end
end