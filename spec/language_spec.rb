require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Redcode Language" do
  context "Parsing" do
    
    it 'ignores comments' do
      commentary_text = <<__END_COMMENTARY__
; This is a comment
; So is this
;and this
org foo
mov 0,1   ; Comments are allowed after code, too!
__END_COMMENTARY__
      
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
      warrior = Warrior.new "org imp\nimp: mov imp, imp2\nimp2: dat 0,0"
      warrior.should_not be_nil
      warrior.labels[:imp].should == 0
      warrior.labels[:imp2].should == 1
    end

    it 'can parse instructions with a modified opcode' do
      pending "Not yet implemented."
      program = "div.a 9, 3"
      warrior = Warrior.new program
      warrior.should_not be_nil
      warrior.instructions.first.value[:opcode].should == :div
      warrior.instructions.first.value[:modifier].should == :a
    end
  end
  
  context 'parsing errors and handling them' do
    it 'should throw an exception for a parse error' do
      (->{Warrior.new("Ce n'est pas un guerrier")}).should raise_error
    end
  end
  
end
