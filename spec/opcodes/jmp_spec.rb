require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The JMP instruction" do
  before(:each) do
    @core = Mars.new
  end
  
  it 'should jump a label when told to' do
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
  end
  
  it 'should jump a relative address when told to' do
    jumper = Warrior.new %q{
      jumper: jmp 6       ;; Line 0
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
  end
  
  it 'should be able to jump backwards to a label' do
    jumper = Warrior.new %q{
              org jumper
      jumpto: jmp 6       ;; Line 0
              dat #1, #1  ;; Line 1
              dat #1, #1  ;; Line 2
              dat #1, #1  ;; Line 3
              dat #1, #1  ;; Line 4
              dat #1, #1  ;; Line 5
      jumper: jmp jumpto  ;; Line 6
    }
    @core.register_warrior jumper
    @core.warriors.first.tasks.first.should == jumper.org - 0
    @core.step
    @core.warriors.first.tasks.first.should == jumper.org - 6
  end
  
  it 'should be able to jump backwards to a relative address' do
    jumper = Warrior.new %q{
              org jumper
      jumpto: jmp 6       ;; Line 0
              dat #1, #1  ;; Line 1
              dat #1, #1  ;; Line 2
              dat #1, #1  ;; Line 3
              dat #1, #1  ;; Line 4
              dat #1, #1  ;; Line 5
      jumper: jmp -6      ;; Line 6
    }
    @core.register_warrior jumper
    @core.warriors.first.tasks.first.should == jumper.org - 0
    @core.step
    @core.warriors.first.tasks.first.should == jumper.org - 6
  end
  
end