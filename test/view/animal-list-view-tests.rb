$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class AnimalViewTests < FreshDatabaseTestCase
  include ViewHelper

  def setup
    super
    Animal.random(:name => '333')
    Animal.random(:name => '111')
    Animal.random(:name => '222')
    @date_source = flexmock("date source",
                            :current_date_as_string => '2010-09-08',
                            :current_date => Date.parse('2010-09-08')).by_default
    @view = AnimalListView.new(:animals => Animal.all, :date_source => @date_source)
  end
  
  should "sort animals by name" do
    actual_names = @view.sorted_by_name(Animal.all).map(&:name)
    expected_names = ['111', '222', '333'] 
    assert { expected_names == actual_names }
  end

  should "show all the animals" do 
    html = @view.to_s
    Animal.names.each do | a | 
      assert { html.include?(a) }
    end
  end

  context "when animals have been removed from service" do 
    setup do 
      Animal[:name => '111'].remove_from_service_as_of('1989-08-12')
      Animal[:name => '222'].remove_from_service_as_of('2009-11-19')
      @view = AnimalListView.new(:animals => Animal.all, :date_source => @date_source)
    end

    should "not show them" do 
      during {
        @view.to_s
      }.behold! { 
        @date_source.should_receive(:current_date).and_return(Date.parse('2009-11-18'))
      }
      deny { @result.include?('111') } # removed
      assert { @result.include?('222') } # not removed yet
      assert { @result.include?('333') } # never removed
    end
  end

  should "contain a delete button" do
    during { 
      @view.to_s
    }.behold! { 
      @date_source.should_receive(:current_date_as_string).and_return('2012-01-03')
    }
    assert { @result.include? delete_button("animal/#{Animal.first.id}?as_of=2012-01-03") } 
  end
end

