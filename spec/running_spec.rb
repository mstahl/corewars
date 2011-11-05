require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'pp'

describe "Running Redcode programs" do
  before(:all) do
    @core = Mars.new
  end
  
  context 'the mov opcode' do
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
    
    
  end
  
end

