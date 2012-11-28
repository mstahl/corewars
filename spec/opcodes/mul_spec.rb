require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The MUL instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to add two numbers' do
    warrior = Warrior.new %q{
               org warrior
      warrior: mul 1, 2
               dat #3, #5
               dat #7, #9
    }
    @core.register_warrior warrior
    @core.step

    @core[warrior.org + 1][:a].should == 3
    @core[warrior.org + 1][:b].should == 5
    @core[warrior.org + 2][:a].should == 21
    @core[warrior.org + 2][:b].should == 45
  end
end
