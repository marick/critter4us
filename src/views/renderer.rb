require './src/routes/requires'

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

  def render_json(structure)
    structure.to_json
  end
end
