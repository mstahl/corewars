require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'pp'

describe "Corewars" do
  context 'configuration' do
    it 'should have a default configuration' do
      cw = Mars.new
      cw.config[:core_size        ].should == 8192
      cw.config[:cycles_before_tie].should == 100_000
      cw.config[:fill             ].should == :dat
      cw.config[:size_limit       ].should == 256
      cw.config[:thread_limit     ].should == 64
      cw.config[:min_separation   ].should == 512
      cw.config[:read_limit       ].should == -1
      cw.config[:separation       ].should == 512
      cw.config[:write_limit      ].should == -1
    end
    
    it 'should be configurable' do
      cw = Mars.new :core_size         => 1,
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
  
  context 'the actual core' do
    before(:each) do
      @core = Mars.new
    end
    
    it 'should not be able to set the value of a memory cell to just anything' do
      (->{ @core[9] = 382975.38299904 }).should raise_error
    end
    
    it 'should be able to get the value of any memory cell' do
      @core[0]    = "mov 0, 1"
      @core[4096] = Mars.parse("add 8, 9")
      
      @core[0].value[:opcode].should    == :mov
      @core[4096].value[:opcode].should == :add
    end
    
    it 'should be able to place a Warrior onto the core' do
      @core[0] = Warrior.new %q{
        add 0, 1
        sub 2, 3
        mul 4, 5
        div 6, 7
      }
      @core[0].value[:opcode].should == :add
      @core[1].value[:opcode].should == :sub
      @core[2].value[:opcode].should == :mul
      @core[3].value[:opcode].should == :div
    end
    
    it 'should be able to register warriors' do
      warrior = Warrior.new %q{
            add 0, 1
            sub 2, 3
            mul 4, 5
        foo:div 6, 7
      }
      @core.register_warrior warrior
      @core.warriors.count.should == 1
      warrior.org.should >= 0
      warrior.org.should < 8192
      @core[warrior.org].value[:opcode].should == :add
      @core[warrior.labels[:foo]].value[:opcode].should == :div
      @core.process_queue.first.should == warrior.org
    end
    
  end
end
