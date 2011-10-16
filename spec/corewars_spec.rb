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

describe "Corewars" do
  it 'can parse the imp program' do
    imp = Corewars.parse @@imp
    imp.instructions[0].opcode.should == 'mov'      # Opcodes are strings
    imp.instructions[0].a_operand.should == :imp    # Symbols are labels in the redcode
  end
end
