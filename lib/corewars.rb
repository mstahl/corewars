# Corewars
# corewars.rb
# 
# Represents a single, ongoing simulation of multiple Redcode programs sharing
# a core of a customizable size.

require 'redcode'   # Will be preprocessed by Polyglot with Treetop

class Corewars
  # Simulation variables
  attr_reader :core_size
  attr_reader :core

  def initialize(options)
    @core_size = options[:core_size] || 8192
  end
  
  def register_warrior ; end
  
  def run ; end
  
  def step ; end
end