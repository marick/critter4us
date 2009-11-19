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
                            :current_date_as_string => '2010-09-08').by_default
    @view = AnimalListView.new(:animals => Animal.all, :date_source => @date_source)
  end
  
  should "sort animals by name" do
    actual_names = @view.animals_sorted_by_name.map(&:name)
    expected_names = ['111', '222', '333'] 
    assert { expected_names == actual_names }
  end

  should "show all the animals" do 
    html = @view.to_s
    Animal.names.each do | a | 
      assert { html.include?(a) }
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

