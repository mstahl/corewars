require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The JMP instruction" do
  before(:each) do
    @core = Mars.new
  end
  
  it 'should jump when told to' do
    jumper = Warrior.new %q{
      jumper: jmp jumpto  ;; Line 0
              dat #1, #1  ;; Line 1
              dat #1, #1  ;; Line 2
              dat #1, #1  ;; Line 3
              dat #1, #1  ;; Line 4
              dat #1, #1  ;; Line 5
      jumpto: jmp jumper  ;; Line 6
    }
    @core.register_warrior jumper
    @core.warriors.first.tasks.first.should == jumper.org + 0
    @core.step
    @core.warriors.first.tasks.first.should == jumper.org + 6
    @core.step
    @core.warriors.first.tasks.first.should == jumper.org + 0
  end
end