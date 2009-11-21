require 'view/util'

class AnimalDeletionCell < Erector::Widget
  include ViewHelper
  needs :animal, :proposed_removal_from_service_date

  def content
    dates_to_be_used = @animal.dates_used_after_beginning_of(@proposed_removal_from_service_date)
    if dates_to_be_used.empty?
      form_data = "animal/#{@animal.id}?as_of=#{@proposed_removal_from_service_date}"
      rawtext delete_button(form_data)
    else
      text "Reserved on #{dates_to_be_used.join(', ')}"
    end
  end
end


class AnimalListView < Erector::Widget
  include ViewHelper
  needs :animal_source, :date_source
  needs :deletion_cell_class => AnimalDeletionCell

  def content
    @animals = @animal_source.all
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
              td { widget @deletion_cell_class,
                          :animal => a, :proposed_removal_from_service_date => today }
            end
          end
        end
      end
    end
  end

  def sorted_by_name(animals)
    animals.sort { |a, b| a.name <=> b.name }
  end

  def in_service(animals)   # TODO: make this a method on Animal class?
    animals.find_all do | a | 
      a.in_service_on?(@date_source.current_date)
    end
  end
end
