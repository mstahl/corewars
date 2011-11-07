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

    @warriors = []
  end
  
  def register_warrior(warrior)
    @warriors << warrior
    self[rand(@core.length)] = warrior
    @process_queue << warrior.org
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
    when :jmp
      program_counter = a_pointer
    else
      raise "I can't understand this instruction: #{current_instruction.text_value}"
    end
    
    # Rotate the process queue
    unless program_counter.nil?
      current_warrior.tasks << program_counter
    end
    # Rotate the warrior queue
    @warriors << current_warrior
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
  
  private
  
  # Private methods ###########################################################
  
  def evaluate_operand(operand, instr, pc, warrior)
    case instr["#{operand}_mode".to_sym]
    when "#"          # Immediate
      a_pointer = pc + 0
      a_instruction = @core[a_pointer].value
      a_value = instr[:a]
    when "$",nil      # Direct
      if instr[:a].is_a? Symbol then
        a_pointer = warrior.labels[instr[:a]]
      else
        a_pointer = pc + instr[:a]
      end
    # when "@"          # Indirect
    # when "{"          # A-Indirect Predecrement
    # when "<"          # B-Indirect Predecrement
    # when "}"          # A-Indirect Postincrement
    # when ">"          # B-Indirect Postincrement
    else
      raise "Operand mode not (yet?) supported: '#{instr[:a_mode]}'"
    end
    
    return [a_value, a_pointer, a_instruction]
  end
  
end
