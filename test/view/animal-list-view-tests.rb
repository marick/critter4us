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
  end

  def view_itself
    mock = flexmock(@view)

    def mock.should_pass(*args)
      key = args[0]
      expected = args[-1]
      if args.size == 3
        selector = args[1]
        p = proc { | h | 
          h[key].send(selector) == expected
        } 
      else
        p = proc { | h | h[key] == expected } 
      end
      @second_arg_components ||= []
      @second_arg_components << p
      puts "#{self.object_id} has #{@second_arg_components.size} checks"
      self
    end

    def mock.and(*args); should_pass(*args); end

    def mock.to(widget_class)
      components = @second_arg_components
      should_receive(:widget).with(widget_class,
                                   FlexMock::ProcMatcher.new { |x|
                                     puts "checking #{x.inspect}"
                                     components.all? do | p | 
                                       puts "component #{p.inspect}"
                                       p.call(x)
                                     end
                                   })
    end

    mock
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
      expected_names = ['111', '222', '333'] 
      assert { expected_names == actual_names }
    end

    should "use a sub-widget to fill in the deletion cell" do
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
      during { 
        @view.to_s
      }.behold! { 
        @date_source.should_receive(:current_date_as_string).and_return('2012-01-03')
        view_itself.should_pass(:animal, :name, '111').
                    and(:today, '2012-01-03').to(DeletionCell)
        view_itself.should_pass(:animal, :name, '222').
                    and(:today, '2012-01-03').to(DeletionCell)

#         view_itself.should_receive(:widget).with(DeletionCell, 
#                                                  on { | h | 
#                                                    h[:animal].name == '222' &&
#                                                    h[:today] == '2012-01-03'})
        view_itself.should_receive(:widget).with(DeletionCell, 
                                                 on { | h | 
                                                   h[:animal].name == '333' &&
                                                   h[:today] == '2012-01-03'})
      }
#      assert { @result.include? delete_button("animal/#{Animal.first.id}?as_of=2012-01-03") } 
    end
  end

  context "when animals have been removed from service" do 
    setup do 
      Animal[:name => '111'].remove_from_service_as_of('1989-08-12')
      Animal[:name => '222'].remove_from_service_as_of('2009-11-19')
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
    end

    should "show only animals that have not been removed" do 
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

  context "animals reserved in future" do 
    setup do 
      @view = AnimalListView.new(:animal_source => Animal,
                                 :date_source => @date_source)
    end

    should_eventually "show dates instead of deletion button" do
      during { 
        @view.to_s
      }.behold! { 
        @date_source.should_receive(:current_date_as_string).and_return('2012-01-03')
      }
      assert { @result.include? delete_button("animal/#{Animal.first.id}?as_of=2012-01-03") } 
    end
  end
end

