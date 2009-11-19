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
          animals = in_service(sorted_by_name(@animals))
          animals.each do | a |
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

  def sorted_by_name(animals)
    animals.sort { |a, b| a.name <=> b.name }
  end

  def in_service(animals)
    animals.find_all do | a | 
      a.in_service_on?(@date_source.current_date)
    end
  end
end
