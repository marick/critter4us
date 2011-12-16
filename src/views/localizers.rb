require './strangled-src/view/href'

module Localizers

  ByPage = {}

  def self.to_localize(page, *lambdas)
    ByPage[page] = lambdas
  end

  def self.locals_for_page(page, data)
    lambdas = ByPage[page]
    lambdas.reduce({}) do | so_far, l | 
      so_far.merge(l.(data))
    end
  end
      
  Pass_reservation_along = -> data do
    { reservation: data[:reservation] } 
  end

  Pass_fulfillment_along = -> data do 
    { rest_links: [ data[:fulfillment] ] }
  end

  to_localize(:reservation__repetition_adder, 
              Pass_reservation_along,
              Pass_fulfillment_along,
              -> data do
                { start_date: data[:reservation].first_date }
              end)

    
  to_localize(:reservation__note_editor,
              Pass_reservation_along,
              Pass_fulfillment_along)

end



