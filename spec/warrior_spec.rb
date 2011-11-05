require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Warrior" do
  context 'warrior metadata' do
    before :all do
      @warrior = Warrior.new %q{
        ;@name The Sheep-Terrorizer
        ;@author max thom stahl <max@villainousindustri.es>
        ;@strategy Lorem ipsum dolor sit amet, consectetur adipisicing elit,
        ;@strategy sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        ;@strategy Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
        ;@strategy nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
        ;@strategy reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        ;@strategy pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
        ;@strategy culpa qui officia deserunt mollit anim id est laborum.
            dat #13, #13
            org foo
        foo:mov 0, 1
            dat #0, #0
            end sheep_terrorizer
      }
    end

    it 'reads author from the comments at the beginning of the file' do
      @warrior.metadata[:author].should == 'max thom stahl <max@villainousindustri.es>'
    end

    it 'reads name correctly from the beginning of the file' do
      @warrior.metadata[:name].should == 'The Sheep-Terrorizer'
    end

    it 'reads multi-line strategy, too' do
      @warrior.metadata[:strategy].should =~ /^Lorem ipsum dolor sit amet/
      @warrior.metadata[:strategy].should =~ /elit, sed do eiusmod/
      @warrior.metadata[:strategy].should =~ /mollit anim id est laborum.$/
    end
    
    it 'interprets the "org" instruction properly' do
      @warrior.org.should == 1
      
      warrior2 = Warrior.new %q{
        add 1,2
        sub 3,4
        mul 5,6
        div 7,8
      }
      warrior2.org.should == 0
    end
    
    it 'interprets the "end" instruction properly' do
      @warrior.end.should == 3
    end

  end
  
  context 'being placed onto the core' do
    before(:all) do
      @warrior = Warrior.new %q{
        foo:mov 0, 1
            add 4, 5
            dat #0, #0
            dat #1, #1
        bar:div 4, 5
      }
    end
    
  end
  
end