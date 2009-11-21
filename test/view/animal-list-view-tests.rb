$: << '../..' unless $in_rake
require 'test/testutil/requires'
require 'model/requires'
require 'view/requires'
require 'assert2/xhtml'

class AnimalViewTests < FreshDatabaseTestCase
  include ViewHelper
  include ErectorTestSupport

  def setup
    super
    Animal.random(:name => 'three333')
    Animal.random(:name => 'aaaaa')
    Animal.random(:name => 'LOWER')
    @date_source = flexmock("date source",
                            :current_date_as_string => '2010-09-08',
                            :current_date => Date.parse('2010-09-08')).by_default
  end

  context "simple case" do 
    setup do 
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
    end

    should "show all the animals" do 
      html = @view.to_s
      Animal.names.each do | a | 
        assert { html.include?(a) }
      end
    end

    should "sort animals by name" do
      actual_names = @view.sorted_by_name(Animal.all).map(&:name)
      expected_names = ['aaaaa', 'LOWER', 'three333'] 
      assert { expected_names == actual_names }
    end

    should "use a sub-widget to fill in the deletion cell" do
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
      during { 
        @view.to_s
      }.behold! { 
        @date_source.should_receive(:current_date_as_string).and_return('2012-01-03')
        view_itself.should_use_widget(AnimalDeletionCell).
                    handing_it([:animal, 'with', :name] => 'aaaaa',
                               :proposed_removal_from_service_date => '2012-01-03')
        view_itself.should_use_widget(AnimalDeletionCell).
                    handing_it([:animal, 'with', :name] => 'LOWER',
                               :proposed_removal_from_service_date => '2012-01-03')
        view_itself.should_use_widget(AnimalDeletionCell).
                    handing_it([:animal, 'with', :name] => 'three333',
                               :proposed_removal_from_service_date => '2012-01-03')
      }
    end
  end

  context "when animals have been removed from service" do 
    setup do 
      Animal[:name => 'aaaaa'].remove_from_service_as_of('1989-08-12')
      Animal[:name => 'LOWER'].remove_from_service_as_of('2009-11-19')
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
    end

    should "show only animals that have not been removed" do 
      during {
        @view.to_s
      }.behold! { 
        @date_source.should_receive(:current_date).and_return(Date.parse('2009-11-18'))
      }
      deny { @result.include?('aaaaa') } # removed
      assert { @result.include?('LOWER') } # not removed yet
      assert { @result.include?('three333') } # never removed
    end
  end

end

