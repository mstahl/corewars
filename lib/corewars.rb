# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

require 'polyglot'
require 'treetop'

require 'corewars/redcode'
require 'corewars/semantics'
require 'corewars/warrior'
require 'pp'

class Mars
  # Simulation variables
  attr_reader :core
  attr_reader :config
  attr_reader :process_queue
  attr_reader :warriors
  
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
    @warriors[warrior.class.to_s.to_sym] = warrior
    self[rand(@core.length)] = warrior
    @process_queue << warrior.org
  end
  
  def run ; end
  
  def step
    current_instruction = @core[@process_queue.first]
    pc = @process_queue.shift
    
    case current_instruction.value[:opcode]
    when :mov
      @core[pc + current_instruction.value[:b]] = @core[pc + current_instruction.value[:a]]
      pc += 1
    else
      raise "I can't understand this instruction: #{current_instruction.text_value}"
    end
    
    # Rotate the process queue
    @process_queue << pc
  end
  
  # Managing the contents and state of the core ###############################
  
  def [](i)
    @core[i]
  end
  
  def []=(i, val)
    if val.is_a? String then
      @core[i] = Mars.parse(val)
    elsif val.is_a? Instruction then
      @core[i] = val
    elsif val.is_a? Warrior then
      val.instructions.each_with_index do |inst, j|
        @core[i + j] = inst
      end
      val.placed_at(i)
    else
      raise "argument must be an Instruction or String"
    end
    val
  end
  
  # Class methods #############################################################
  
  def self.parse(text)
    parser = RedcodeParser.new
    result = parser.parse text
    unless result
      err =  "#{parser.failure_reason}:\n"
      err << "'#{text}'\n"
      err << " " + (" " * parser.failure_column.to_i) + "^\n"
      raise err
    end
    result
  end
  
end

