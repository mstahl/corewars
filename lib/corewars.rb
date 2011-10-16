# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

class Corewars
  # Simulation variables
  attr_reader :core_size
  attr_reader :core

  def initialize(options)
    @core_size = options[:core_size] || 8192
    @core = 
  end
  
  
end