require './test/testutil/requires'
require './model/requires'
require './views/requires'

class RendererTests < ViewTestCase

  should "be able to render Textile" do
    html = @renderer.render_textile("**should**")
    assert { %r{<b>should</b>} =~ html }
  end

  # Rendering HAML is tested implicitly by page tests.
end
