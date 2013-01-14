require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Redcode Language" do
  context "Parsing" do
    
    it 'ignores comments' do
      commentary_text = %{
        ; This is a comment
        ; So is this
        ;and this
        org foo
        mov 0,1   ; Comments are allowed after code, too!
      }
      
      commentary = Warrior.new commentary_text
      commentary.should_not be_nil
      commentary.instructions.length.should == 1
    end

    it 'can parse an instruction with single operand' do
      warrior = Warrior.new "org 3"
      warrior.should_not be_nil
    end
    
    it 'can parse an instruction with two operands' do
      warrior = Warrior.new "mov 0,1"
      warrior.should_not be_nil
      warrior.instructions.first.value[:opcode].should == :mov
      warrior.instructions.first.value[:a].should == 0
      warrior.instructions.first.value[:b].should == 1
    end
    
    it 'can parse instructions with modes on operands' do
      warrior = Warrior.new "mul $0, @foo"
      warrior.should_not be_nil
      warrior.instructions.first.value[:opcode].should == :mul
      warrior.instructions.first.value[:a].should == 0
      warrior.instructions.first.value[:a_mode].should == '$'
      warrior.instructions.first.value[:b].should == :foo
      warrior.instructions.first.value[:b_mode].should == '@'
    end
    
    it 'can parse instructions with one mode on one operand' do
      warrior = Warrior.new "mul 0, @foo"
      warrior.should_not be_nil
      warrior.instructions.first.value[:opcode].should == :mul
      warrior.instructions.first.value[:a].should == 0
      warrior.instructions.first.value[:a_mode].should == nil
      warrior.instructions.first.value[:b].should == :foo
      warrior.instructions.first.value[:b_mode].should == '@'
    end
    
    it 'can parse instructions with one mode on the other operand' do
      warrior = Warrior.new "mul #0, foo"
      warrior.should_not be_nil
      warrior.instructions.first.value[:opcode].should == :mul
      warrior.instructions.first.value[:a].should == 0
      warrior.instructions.first.value[:a_mode].should == '#'
      warrior.instructions.first.value[:b].should == :foo
      warrior.instructions.first.value[:b_mode].should == nil
    end
    
    it 'collects labels attached to instructions' do
      warrior = Warrior.new %{
              org imp
        imp:  mov imp, imp2
        imp2: dat 0,0
      }
      warrior.should_not be_nil
      warrior.labels[:imp].should == 0
      warrior.labels[:imp2].should == 1
    end

    context 'with a modified opcode' do
      it 'should understand the :a modifier' do
        warrior = Warrior.new "div.a 9, 3"
        p warrior.instructions.first.value
        warrior.instructions.first.value[:modifier].should == :a
      end

      it 'should understand the :b modifier' do
        warrior = Warrior.new "div.b 9, 3"
        warrior.instructions.first.value[:modifier].should == :b
      end

      it 'should understand the :ab modifier' do
        warrior = Warrior.new "div.ab 9, 3"
        warrior.instructions.first.value[:modifier].should == :ab
      end

      it 'should understand the :ba modifier' do
        warrior = Warrior.new "div.ba 9, 3"
        warrior.instructions.first.value[:modifier].should == :ba
      end

      it 'should understand the :f modifier' do
        warrior = Warrior.new "div.f 9, 3"
        warrior.instructions.first.value[:modifier].should == :f
      end

      it 'should understand the :x modifier' do
        warrior = Warrior.new "div.x 9, 3"
        warrior.instructions.first.value[:modifier].should == :x
      end

      it 'should understand the :i modifier' do
        warrior = Warrior.new "div.i 9, 3"
        warrior.instructions.first.value[:modifier].should == :i
      end
    end
  end
  
  context 'parsing errors and handling them' do
    it 'should throw an exception for a parse error' do
      (->{Warrior.new("Ce n'est pas un guerrier")}).should raise_error
    end
  end
  
end
