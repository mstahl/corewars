require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The MOD instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to modulo two numbers' do
    warrior = Warrior.new %q{
               org warrior
      warrior: mod 1, 2
               dat #13, #35
               dat #5, #6
    }
    @core.register_warrior warrior
    @core.step

    @core[warrior.org + 1][:a].should == 13
    @core[warrior.org + 1][:b].should == 35
    @core[warrior.org + 2][:a].should == 3
    @core[warrior.org + 2][:b].should == 5
  end
end
