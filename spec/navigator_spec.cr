require "./spec_helper"

def alphabet_navigator
  return Marbles::Navigator.new(%w{
    ABCD
    EFGH
    IJKL
    })
end

describe "Navigator" do
  it "finds a single character within the grid" do
    myNav = Marbles::Navigator.new(%w{
      000000000000
      000000000
      00000000000
      000010000
      00000000000
      })
    myNav.find('1').should eq([{3, 4}])
  end

  it "finds all occurrences of a character within the grid" do
    myNav = Marbles::Navigator.new(%w{
      0000000
      0100000
      0010000
      0001000
      0000100
      0000010
      0000000
      })
    myNav.find('1').should eq([{1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}])
  end

  it "returns an empty array when a character is not found in the grid" do
    myNav = alphabet_navigator
    myNav.find('1').should eq([] of Tuple(Int32, Int32))
  end

  it "moves downwards successfully" do
    myNav = alphabet_navigator
    myNav.down.should eq('E')
    myNav.down.should eq('I')
    myNav.down.should eq(nil)
    myNav.current.should eq('I')
  end

  it "moves upwards successfully" do
    myNav = alphabet_navigator
    myNav.up.should eq(nil)
    myNav.current.should eq('A')
    myNav.goto 2, 0
    myNav.up.should eq('E')
    myNav.up.should eq('A')
  end

  it "moves to the right successfully" do
    myNav = alphabet_navigator
    myNav.right.should eq('B')
    myNav.right.should eq('C')
    myNav.right.should eq('D')
    3.times do
      myNav.right.should eq(' ')
    end
  end

  it "moves to the left successfully" do
    myNav = alphabet_navigator
    myNav.left.should eq(nil)
    myNav.current.should eq('A')
    myNav.goto 0, 3
    myNav.left.should eq('C')
    myNav.left.should eq('B')
    myNav.left.should eq('A')
  end
end
