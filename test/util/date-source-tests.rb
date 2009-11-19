$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'util/requires'

class DateSourceTests < Test::Unit::TestCase
  should "return current date" do
    during { 
      DateSource.new.current_date
    }.behold! {
      flexmock(Time).should_receive(:now).and_return(Time.parse('2012-01-06'))
    }
    assert { @result == Date.parse('2012-01-06') } 
  end
 
 should "return current date as a string" do
    during { 
      DateSource.new.current_date_as_string
    }.behold! {
      flexmock(Time).should_receive(:now).and_return(Time.parse('2012-01-06'))
    }
    assert { @result == '2012-01-06' } 
  end
end
