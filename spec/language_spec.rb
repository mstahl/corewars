require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Redcode Language" do
  context "Parsing" do
    
    it 'ignores comments' do
      commentary_text = <<__END_COMMENTARY__
; This is a comment
; So is this
;and this
;@author max thom stahl
;@strategy Does nothing.
__END_COMMENTARY__
      
      commentary = Warrior.new commentary_text
      commentary.should_not be_nil
      commentary.instructions.length.should == 0
    end
    
    it 'can parse the simple program' do
      simple_text = <<__END_SIMPLE__
org foo
mov 0,1
__END_SIMPLE__
      simple = Warrior.new simple_text.strip
      simple.should_not be_nil

      puts "{"
      pp simple
      puts "}"
    end
  end
end