require './controller/base'

class Renderer

  def initialize
    @controller = Controller.actual_object
  end

  def render_page(page, locals)
    @controller.haml(page, :locals => locals)
  end
end
