
require 'polyglot'
require 'treetop'

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each {|f| require f}

class Warrior < Treetop::Runtime::SyntaxNode
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
        instruction = Corewars.parse line
        
        if instruction then
          @instructions << instruction.value
        else
          throw "Parse error on line #{line_no + 1}: '#{line}'"
        end
      end
    end
    
    # Should do something with labels here....
    @instructions.each_with_index do |instruction, address|
      if instruction[:labels] then
        @labels[instruction[:labels].to_sym] = address   # Label addresses are stored here relative to start of program
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
