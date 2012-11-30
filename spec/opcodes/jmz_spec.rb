require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The JMZ instruction" do

  before(:each) do
    @core = Mars.new
  end
  
  context 'with zero B-argument' do
    it 'should jump to a label when its B argument is zero' do
      jumper = Warrior.new %q{
        jumper: jmz jumpto, #0 ;; Line 0
                dat #1, #1     ;; Line 1
                dat #1, #1     ;; Line 2
                dat #1, #1     ;; Line 3
                dat #1, #1     ;; Line 4
                dat #1, #1     ;; Line 5
        jumpto: jmp jumper     ;; Line 6
      }
      @core.register_warrior jumper
      @core.warriors.first.tasks.first.should == jumper.org + 0
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org + 6
    end
    
    it 'should jump a relative address when told to' do
      jumper = Warrior.new %q{
        jumper: jmz 6, #0   ;; Line 0
                dat #1, #1  ;; Line 1
                dat #1, #1  ;; Line 2
                dat #1, #1  ;; Line 3
                dat #1, #1  ;; Line 4
                dat #1, #1  ;; Line 5
        jumpto: jmp jumper  ;; Line 6
      }
      @core.register_warrior jumper
      @core.warriors.first.tasks.first.should == jumper.org
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org + 6
    end
    
    it 'should be able to jump backwards to a label' do
      jumper = Warrior.new %q{
                org jumper
        jumpto: jmz 6, #0       ;; Line 0
                dat #1, #1      ;; Line 1
                dat #1, #1      ;; Line 2
                dat #1, #1      ;; Line 3
                dat #1, #1      ;; Line 4
                dat #1, #1      ;; Line 5
        jumper: jmz jumpto, #0  ;; Line 6
      }
      @core.register_warrior jumper
      @core.warriors.first.tasks.first.should == jumper.org
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
        jumper: jmz -6, #0  ;; Line 6
      }
      @core.register_warrior jumper
      @core.warriors.first.tasks.first.should == jumper.org
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org - 6
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org
    end
  end
  
end
