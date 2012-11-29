require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The MUL instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to add two numbers' do
    warrior = Warrior.new %q{
               org warrior
      warrior: sub 1, 2
               dat #9, #7
               dat #3, #4
    }
    @core.register_warrior warrior
    @core.step

    @core[warrior.org + 1][:a].should == 9
    @core[warrior.org + 1][:b].should == 7
    @core[warrior.org + 2][:a].should == 6
    @core[warrior.org + 2][:b].should == 3
  end
end
