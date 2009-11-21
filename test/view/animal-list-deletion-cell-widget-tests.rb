$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class AnimalListDeletionCellWidgetTests < Test::Unit::TestCase
  include ViewHelper

  def setup
    super
    @proposed_removal_from_service_date = '2010-09-08'
    @animal = flexmock("animal", :id => 'some id').by_default
    @widget = AnimalDeletionCell.new(:animal => @animal, :proposed_removal_from_service_date => @proposed_removal_from_service_date)
  end

  should "produce a 'delete' button if in no future reservations" do
    during { 
      @widget.to_s
    }.behold! { 
      @animal.should_receive(:dates_used_after_beginning_of).
              with(@proposed_removal_from_service_date).
              and_return([])
    }
    action = "animal/#{@animal.id}"
    default_date = @proposed_removal_from_service_date
    assert_xhtml(@result) do
      form(:method => "POST", :action => action) do
        input(:type => "submit", :value => 'Remove from service')
        input(:name => "_method", :value => "DELETE")
        input(:type => "text", :value => default_date)
      end
    end
  end

  should "procedure a list of dates if future reservations" do 
    dates_to_be_used = ['2012-01-02', '2013-03-01', '2013-03-02']
    during { 
      @widget.to_s
    }.behold! { 
      @animal.should_receive(:dates_used_after_beginning_of).
              with(@proposed_removal_from_service_date).
              and_return(dates_to_be_used)
    }
    assert { @result =~ /#{dates_to_be_used.join('.*')}/  } 
  end
end
