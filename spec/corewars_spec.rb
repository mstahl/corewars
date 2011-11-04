require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
  
end
