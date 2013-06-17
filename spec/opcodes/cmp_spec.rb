require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pp'

describe "The CMP instruction" do
  before(:each) do
    @core = Mars.new
  end

  it 'should be able to compare two equal numbers with CMP' do
    comparator = Warrior.new %q{
                  org comparator
      comparator: cmp 1, 2
                  dat #3, #3
                  dat #3, #3
    }
    @core.register_warrior comparator
    @core.step
    comparator.tasks[0].should == comparator.org + 2
  end

  it 'should be able to compare two unequal numbers with CMP' do
    comparator = Warrior.new %q{
                  org comparator
      comparator: cmp 1, 2
                  dat #3, #3
                  dat #4, #4
    }
    @core.register_warrior comparator
    @core.step
    comparator.tasks[0].should == comparator.org + 1
  end

end
