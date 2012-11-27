require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The ADD instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to add two numbers' do
    adder = Warrior.new %q{
              org adder
      adder:  add 1, 2
              dat #3, #5
              dat #7, #9
    }
    @core.register_warrior adder
    @core.step

    @core[adder.org + 1].value[:a].should == 3
    @core[adder.org + 1].value[:b].should == 5
    @core[adder.org + 2].value[:a].should == 10
    @core[adder.org + 2].value[:b].should == 14
  end
end
