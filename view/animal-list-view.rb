require 'view/util'

class AnimalListView < Erector::Widget
  include ViewHelper

  def content
    html do 
      head do
        title 'All Animals'
      end
      body do
        table(TableStyle) do 
          th do 
          end
          animals_sorted_by_name.each do | a |
            tr do 
              td { text a.name }
              td { rawtext delete_button("animal/#{a.id}") }
            end
          end
        end
      end
    end
  end

  def animals_sorted_by_name 
    @animals.sort { |a, b| a.name <=> b.name }
  end
end
