require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Redcode Language" do
  context "Parsing" do
    
#     it 'ignores comments' do
#       commentary_text = <<__END_COMMENTARY__
# ; This is a comment
# ; So is this
# ;and this
# org foo
# mov 0,1   ; Comments are allowed after code, too!
# __END_COMMENTARY__
#       
#       commentary = Warrior.new commentary_text
#       commentary.should_not be_nil
#       commentary.instructions.length.should == 2
#     end

    it 'can parse an instruction with single operand' do
      warrior = Warrior.new "org 3"
      warrior.should_not be_nil
      warrior.instructions.first[:opcode].should == :org
      warrior.instructions.first[:a].should == 3
      warrior.instructions.first[:a_mode].should be_nil
    end
    
    # it 'can parse an instruction with two operands' do
    #   warrior = Warrior.new "mov 0,1"
    #   warrior.should_not be_nil
    #   warrior.instructions.first[:opcode].should == :mov
    #   warrior.instructions.first[:a].should == 0
    #   warrior.instructions.first[:b].should == 1
    # end
    
    # it 'can parse instructions with modes on operands' do
    #   warrior = Warrior.new "mul $0, @foo"
    #   warrior.should_not be_nil
    #   warrior.instructions.first[:operation][:opcode].should == :mul
    #   warrior.instructions.first[:a][:mode].should == '$'
    #   warrior.instructions.first[:b][:mode].should == '@'
    # end
    
    # it 'collects labels attached to instructions' do
    #   warrior = Warrior.new "org imp\nimp: mov imp, imp2\nimp2: dat 0,0"
    #   warrior.should_not be_nil
    #   warrior.labels[:imp].should == 1
    #   warrior.labels[:imp2].should == 2
    # end
    
    # it 'can parse instructions with a modified opcode' do
    #   program = "div.ab 9, 3"
    #   warrior = Warrior.new program
    #   warrior.should_not be_nil
    #   warrior.instructions.first[:operation][:opcode].should == :div
    #   warrior.instructions.first[:operation][:modifier].should == :ab
    # end
  end
  
  context 'metadata' do
    before :all do
      @program = <<__end_of_program__
;@name The Sheep-Terrorizer
;@author max thom stahl <max@villainousindustri.es>
;@strategy Lorem ipsum dolor sit amet, consectetur adipisicing elit,
;@strategy sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
;@strategy Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
;@strategy nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
;@strategy reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
;@strategy pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
;@strategy culpa qui officia deserunt mollit anim id est laborum.
    org foo
foo:mov 0, 1
    dat #0, #0
    end sheep_terrorizer
__end_of_program__
      @warrior = Warrior.new @program
    end
    
    it 'reads author from the comments at the beginning of the file' do
      @warrior.metadata[:author].should == 'max thom stahl <max@villainousindustri.es>'
    end
    
    it 'reads name correctly from the beginning of the file' do
      @warrior.metadata[:name].should == 'The Sheep-Terrorizer'
    end
    
    it 'reads multi-line strategy, too' do
      @warrior.metadata[:strategy].should =~ /^Lorem ipsum dolor sit amet/
      @warrior.metadata[:strategy].should =~ /elit, sed do eiusmod/
      @warrior.metadata[:strategy].should =~ /mollit anim id est laborum.$/
    end
  end
end