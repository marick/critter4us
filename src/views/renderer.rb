require './src/routes/requires'

class Renderer

  def initialize
    @controller = Controller.actual_object
  end

  def render_page(page, data_in_terms_of_app)
    local_var_assignments = Localizers.locals_for_page(page, data_in_terms_of_app)
    @controller.haml(page, :locals => local_var_assignments)
  end

  def render_textile(text)
      RedCloth.new(text).to_html
  end

  def render_json(structure)
    structure.to_json
  end

end
