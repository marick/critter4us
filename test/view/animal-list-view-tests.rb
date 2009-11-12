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
    @view = AnimalListView.new(:animals => Animal.all)
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
    html = @view.to_s
    assert { html.include? delete_button("animal/#{Animal.first.id}") } 
  end
end

