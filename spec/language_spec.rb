require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Imp from http://users.obs.carnegiescience.edu/birk/COREWAR/88/HILL/imp.red
@@imp = <<__END_IMP__
;redcode
;name Imp
;author A.K. Dewdney
;assert 1

imp     mov imp, imp + 1

        end imp
__END_IMP__

@@dwarf = <<__END_DWARF__
;redcode verbose
;name Dwarf
;author A. K. Dewdney
;strategy Throw DAT bombs around memory, hitting every 4th memory cell.
;strategy   This program was presented in the first Corewar article.
;assert (CORESIZE % 4)==0
bomb  dat #0
dwarf add #4, bomb
      mov bomb, @bomb
      jmp dwarf
      end dwarf
__END_DWARF__

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
org balls
__END_SIMPLE__
      simple = Warrior.new simple_text.strip
      simple.should_not be_nil

      puts "{"
      pp simple
      puts "}"
    end
  end
end