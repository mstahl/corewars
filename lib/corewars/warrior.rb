

class Warrior
  attr_reader :instructions
  attr_reader :labels
  
  attr_reader :metadata
  
  attr_reader :org
  attr_reader :end
  
  attr_writer :start_address
  
  attr_accessor :tasks
  
  def initialize(text)
    @instructions = []
    @labels = {}
    @metadata = {}
    @tasks = []
    
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
        instruction.warrior = self
        
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
    
    @tasks << @org
    
  end
  
end