require 'capybara'
require 'assert2'

module HtmlAssertions
  def node_tree(text); Capybara.string(text); end
  
  def assert_text_has_selector(text, *args)
    assert {node_tree(text).has_selector?(*args) }
  end

  def assert_text_has_attributes(text, selector, attr_values)
    nodes = node_tree(text).all(selector)
    assert { nodes.size > 0 }
    nodes.each do | node |
      return if attr_values.all? { | attr, val | val === node[attr.to_s] }
    end
    assert(false, "No attribute match for #{attr_values}.")
  end
    
  # Assumes Rack::Test

  def assert_body_has_selector(*args)
    assert_text_has_selector(last_response.body, *args)
  end

  def assert_body_has_attributes(*args)
    assert_text_has_selector(last_response.body, *args)
  end
end
