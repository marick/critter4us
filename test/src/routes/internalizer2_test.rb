require './test/testutil/requires'
require './src/routes/internalizer2'

class Internalizer2Tests < Test::Unit::TestCase

  def setup
    @subject = Internalizer2.new
    @before_app = Date.new(2007, 1, 1)
  end

  context "#past_date" do
    should "convert strings to numbers" do 
      assert { @subject.days_in_the_past("1") == 1 } 
    end

    should "treat words as 'long ago' (before app existed)" do
      actual = @subject.days_in_the_past("bazillion")
      assert { Date.today - actual < @before_app }
    end

    should "also treat the empty string as 'long ago'" do 
      actual = @subject.days_in_the_past("")
      assert { Date.today - actual < @before_app }
    end
  end
end
