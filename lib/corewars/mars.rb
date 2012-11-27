class Mars
  # Simulation variables
  attr_reader :core
  attr_reader :config
  attr_reader :warriors
  
  def initialize(options = {})
    opts = [:core_size , :cycles_before_tie, :fill , :size_limit , :thread_limit , :min_separation , :read_limit , :separation , :write_limit]
    unless (options.keys - opts).empty?
      raise "Invalid configuration keys: #{(options.keys - opts).map(&:to_s).join(', ')}"
    end
    
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

    @core = [Mars.parse("dat #0, #0")] * @config[:core_size]

    @warriors = []
  end
  
  def register_warrior(warrior, options = {})
    at = 0
    if options.has_key?(:at) and options[:at].is_a?(Fixnum)
      at = options[:at]
    else
      at = rand(@core.length)
    end
    
    @warriors << warrior
    self[at] = warrior
  end
  
  def run ; end
  
  def step
    current_warrior = @warriors.shift
    program_counter = current_warrior.tasks.shift
    
    instruction_register = @core[program_counter].value
    
    # Evaluate A operand, with mode
    a_value, a_pointer, a_instruction = evaluate_operand(:a, instruction_register, program_counter, current_warrior)
    b_value, b_pointer, b_instruction = evaluate_operand(:b, instruction_register, program_counter, current_warrior)

    case instruction_register[:opcode]
    when :dat
      program_counter = nil
    when :jmp
      program_counter = a_pointer
    when :mov
      @core[b_pointer] = @core[a_pointer]
      program_counter += 1
    when :add
      @core[b_pointer] += @core[a_pointer]
      program_counter += 1
    when :sub
      raise "SUB not yet implemented."
      program_counter += 1
    when :mul
      raise "MUL not yet implemented."
      program_counter += 1
    when :div
      raise "DIV not yet implemented."
      program_counter += 1
    when :mod
      raise "MOD not yet implemented."
      program_counter += 1
    when :jmz
      raise "JMZ not yet implemented."
      program_counter += 1
    when :jmn
      raise "JMN not yet implemented."
      program_counter += 1
    when :djn
      raise "DJN not yet implemented."
      program_counter += 1
    when :cmp
      raise "CMP not yet implemented."
      program_counter += 1
    when :slt
      raise "SLT not yet implemented."
      program_counter += 1
    when :spl
      raise "SPL not yet implemented."
      program_counter += 1
    # when :org
    # when :equ
    # when :end
    else
      raise "I can't understand this instruction: #{instruction_register[:opcode]}"
    end
    
    # Rotate the process queue
    unless program_counter.nil?
      current_warrior.tasks << program_counter
    end
    current_warrior.tasks.compact!
    # Rotate the warrior queue
    @warriors << current_warrior
    
    # Filter out any warriors that don't have any code executing right now
    # @warriors.reject! {|w| w.tasks.empty? }
    
    # If there is only one warrior left, end the game
  end
  
  # Managing the contents and state of the core ###############################
  
  def [](i)
    @core[i % @config[:core_size]]
  end
  
  def []=(i, val)
    if val.is_a? String then
      @core[i % @config[:core_size]] = Mars.parse(val)
    elsif val.is_a? Instruction then
      @core[i % @config[:core_size]] = val
    elsif val.is_a? Warrior then
      val.instructions.each_with_index do |inst, j|
        @core[(i + j) % @config[:core_size]] = inst
      end
      val.placed_at(i % @config[:core_size])
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
  
  private
  
  # Private methods ###########################################################
  
  def evaluate_operand(operand, instr, pc, warrior)
    case instr["#{operand}_mode".to_sym]
    when "#"          # Immediate
      a_pointer = pc + 0
      a_instruction = @core[a_pointer].value
      a_value = instr[operand]
    when "$",nil      # Direct
      if instr[operand].is_a? Symbol then
        a_pointer = warrior.labels[instr[operand]]
      else
        a_pointer = instr[operand] ? pc + instr[operand] : nil
      end
    # when "@"          # Indirect
    # when "{"          # A-Indirect Predecrement
    # when "<"          # B-Indirect Predecrement
    # when "}"          # A-Indirect Postincrement
    # when ">"          # B-Indirect Postincrement
    else
      raise "Operand mode not (yet?) supported: '#{instr[:"#{operand}_mode"]}'"
    end
    
    return [a_value, a_pointer, a_instruction]
  end
  
end
