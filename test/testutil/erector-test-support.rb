require 'test/testutil/mock-talk'

module ErectorTestSupport
  def view_itself
    mock = flexmock(@view)

    def mock.should_use_widget(widget_class)
      @widget_class = widget_class
      self
    end

    def mock.handing_it(object_descriptions)
      checks = []
      object_descriptions.each do | description, expected |
        checks << 
          if description.is_a? Array
            selector = description[-1]
            description = description[0]
            proc { | h | h[description].send(selector) == expected }
          else
            proc { | h | h[description] == expected } 
          end
      end
      should_receive(:widget).with(@widget_class,
                                   FlexMock::ProcMatcher.new { |x|
                                     checks.all? do | p | 
                                       p.call(x)
                                     end
                                   })
    end

    mock
  end
end
