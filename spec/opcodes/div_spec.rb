require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The DIV instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to divide two numbers' do
    warrior = Warrior.new %q{
               org warrior
      warrior: div 1, 2
               dat #4 , #3
               dat #32, #27
    }
    @core.register_warrior warrior
    @core.step

    @core[warrior.org + 1][:a].should == 4
    @core[warrior.org + 1][:b].should == 3
    @core[warrior.org + 2][:a].should == 8
    @core[warrior.org + 2][:b].should == 9
  end
end
