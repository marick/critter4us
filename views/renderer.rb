require './controller/base'
require 'RedCloth'

class Renderer

  def initialize
    @controller = Controller.actual_object
  end

  def render_page(page, locals)
    @controller.haml(page, :locals => locals)
  end

  def render_textile(text)
      RedCloth.new(text).to_html
  end
end
