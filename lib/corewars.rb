

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
    @warriors[warrior.class.to_sym] = warrior
  end
  
  def run ; end
  
  def step
    # Each step of the simulation, the next program counter in the process queue
    # must be run. 
  end
  
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