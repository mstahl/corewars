require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The MOV instruction" do
  before(:each) do
    @core = Mars.new
  end
  
  it 'should interpret "mov 0, 1" (with no operand modes) correctly' do
    warrior = Warrior.new %q{
      mov 0,1     ; This is a pretty standard imp
    }
    @core.register_warrior(warrior)
    @core.step
    # Now there should be *two* "mov 0,1" instructions
    @core[warrior.org].value[:opcode].should == :mov
    @core[warrior.org + 1].value[:opcode].should == :mov
    # And the program counter should've been incremented
    @core.process_queue.first.should == warrior.org + 1
  end
  
  # it 'should be able to move backwards' do
  #   pending "Requires full expressions as operands, which isn't gonna happen for a bit."
  #   warrior = Warrior.new %q{
  #     mov 0,-1     ; This is a pretty standard imp
  #   }
  #   @core.register_warrior(warrior)
  #   @core.step
  #   # Now there should be *two* "mov 0,1" instructions
  #   @core[warrior.org].value[:opcode].should == :mov
  #   @core[warrior.org - 1].value[:opcode].should == :mov
  #   # And the program counter should've been incremented
  #   @core.process_queue.first.should == warrior.org + 1
  # end
  
end