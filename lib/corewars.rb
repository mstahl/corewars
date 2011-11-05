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
    
    hash[:a_mode] = a.value[:mode]
    hash[:a] = a.value[:expression]
    
    
    if defined? b
      hash[:b_mode] = b.value[:mode]
      hash[:b] = b.value[:expression]
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
      :mode       => defined? mode ? mode.text_value : nil
    }
  end
end

class Warrior
  attr_reader :instructions
  attr_reader :labels
  
  attr_reader :metadata
  
  attr_reader :org
  attr_reader :end
  
  attr_writer :start_address
  
  def initialize(text)
    @instructions = []
    @labels = {}
    @metadata = {}
    
    text.lines.each_with_index do |line, line_no|
      # Check for metadata
      if line =~ /;@(\w+)\s+(.+)/ then
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
        
        @instructions << instruction
      end
    end
    
    # Before labels, we need to get rid of the 'org' and 'end' instructions, 
    # but hang on to the data they contain.
    @instructions.each_with_index do |instruction, address|
      if instruction.value[:opcode] == :org then
        @org = instruction.value[:a]
        @instructions.delete instruction
      elsif instruction.value[:opcode] == :end then
        @end = address
        @instructions.delete instruction
      end
    end
    
    # Should do something with labels here....
    @instructions.each_with_index do |instruction, address|
      next unless instruction.value[:label] =~ /^[\w\d_\s]+$/
      
      if instruction.value[:label] then
        @labels[instruction.value[:label].to_sym] = address   # Label addresses are stored here relative to start of program
      end
    end
    
    if @org.nil? then
      @org = 0
    else
      @org = @labels[@org]
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
  
  def placed_at(address)
    @start_address = address
    
    @org = @start_address + @org
    
    @labels.each do |lbl, addr|
      @labels[lbl] = @start_address + addr
    end
    
  end
  
end

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

