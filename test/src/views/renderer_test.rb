require './test/testutil/requires'
require './strangled-src/model/requires'
require './src/views/requires'

class RendererTests < ViewTestCase

  should "be able to render Textile" do
    html = @renderer.render_textile("**should**")
    assert { %r{<b>should</b>} =~ html }
  end

  # There are two steps to page rendering. First, the application data is transformed into
  # data that the HAML expects in its local variables. That's tested in localizers_tests.rb.
  # Then the HAML is rendered. That's tested by the various page tests. So all the renderer
  # proper does is this:

  should "be able to render HTML" do 
    @renderer.override_collaborators_with(mocks(:controller, :localizer))
    during {
      @renderer.render_page(:some_page, "a data hash")
    }.behold! {
      @localizer.should_receive(:locals_for_page).once.
                 with(:some_page, "a data hash").
                 and_return("a locals hash")
      @controller.should_receive(:haml).once.
                  with(:some_page, :locals => "a locals hash")
    }
  end

  should "be able to render JSON" do
    a_structure = {:key => ["value1", 3]}
    result = @renderer.render_json(a_structure)
    assert { a_structure.to_json == result }
  end
end
