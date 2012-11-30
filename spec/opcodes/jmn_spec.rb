require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The JMN instruction" do

  before(:each) do
    @core = Mars.new
  end
  
  context 'with nonzero B-argument' do
    it 'should jump to a label' do
      jumper = Warrior.new %q{
        jumper: jmn jumpto, #3 ;; Line 0
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
        jumper: jmn 6, #3   ;; Line 0
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
        jumpto: jmn 6, #3       ;; Line 0
                dat #1, #1      ;; Line 1
                dat #1, #1      ;; Line 2
                dat #1, #1      ;; Line 3
                dat #1, #1      ;; Line 4
                dat #1, #1      ;; Line 5
        jumper: jmn jumpto, #3  ;; Line 6
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
        jumper: jmn -6, #3  ;; Line 6
      }
      @core.register_warrior jumper
      @core.warriors.first.tasks.first.should == jumper.org
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org - 6
      @core.step
      @core.warriors.first.tasks.first.should == jumper.org
    end
  end

  context 'with nonzero B-argument' do
    pending "TODO"
  end
  
end
