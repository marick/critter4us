require 'view/util'

class AnimalListView < Erector::Widget
  include ViewHelper
  needs :animals, :date_source

  def content
    html do 
      head do
        title 'All Animals'
      end
      body do
        table(TableStyle) do 
          animals_sorted_by_name.each do | a |
            tr do 
              td { text a.name }
              today = @date_source.current_date_as_string
              td { rawtext delete_button("animal/#{a.id}?as_of=#{today}") }
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
