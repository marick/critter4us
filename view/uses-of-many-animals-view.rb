require './view/util'

class UsesOfManyAnimalsView < Erector::Widget
  include ViewHelper
  needs :data, :timeslice


  def content
    html do 
      head do
        title(TimesliceUsageText.new(:timeslice => @timeslice).to_s)
      end
      body do
        h1(TimesliceUsageText.new(:timeslice => @timeslice).to_s)
        table(NarrowTableStyle) do 
          animals = @data.keys.sort
          animals.each do | animal | 
            tr do 
              td { text animal }
              td { rawtext highlighted_first_words(count_annotated(without_parens(@data[animal]))).join(', ') }
            end
          end
        end
      end
    end
  end
end
