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
  context 'configuration' do
    it 'should be configurable' do
      cw = Corewars.new
      cw.config[:core_size        ].should == 8192
      cw.config[:cycles_before_tie].should == 100_000
      cw.config[:fill             ].should == :dat
      cw.config[:size_limit       ].should == 256
      cw.config[:thread_limit     ].should == 64
      cw.config[:min_separation   ].should == 512
      cw.config[:read_limit       ].should == -1
      cw.config[:separation       ].should == 512
      cw.config[:write_limit      ].should == -1
      
      cw = Corewars.new :core_size         => 1,
                        :cycles_before_tie => 2,
                        :fill              => :dat,
                        :size_limit        => 3,
                        :thread_limit      => 4,
                        :min_separation    => 5,
                        :read_limit        => 6,
                        :separation        => 7,
                        :write_limit       => 8
      cw.config[:core_size        ].should == 1
      cw.config[:cycles_before_tie].should == 2
      cw.config[:fill             ].should == :dat
      cw.config[:size_limit       ].should == 3
      cw.config[:thread_limit     ].should == 4
      cw.config[:min_separation   ].should == 5
      cw.config[:read_limit       ].should == 6
      cw.config[:separation       ].should == 7
      cw.config[:write_limit      ].should == 8
    end
  end
  
  # it 'can parse the imp program' do
  #   pending "Not finished with this one yet."
  #   imp = Corewars.parse @@imp
  #   imp.instructions[0].opcode.should == 'mov'      # Opcodes are strings
  #   imp.instructions[0].a_operand.should == :imp    # Symbols are labels in the redcode
  # end
end
