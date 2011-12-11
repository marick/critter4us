module Href

  module Task_Uis

    def self.uris(action, subpart)
      defs = %Q{def #{action}_reservation_#{subpart}_match
                 '/2/task-uis/reservation/#{action}-#{subpart}'
                end

                def #{action}_reservation_#{subpart}_generator(reservation_id)
                  #{action}_reservation_#{subpart}_match + "?reservation_id=\#{reservation_id}"
                end
              }
              
      instance_eval(defs)
    end

    uris('edit', 'note')
    uris('add', 'repetitions')


    # def self.make_reservation_copies_match
    #   '/2/task-uis/reservation/make-copies'
    # end

    # def self.make_reservation_copies_generator(reservation_id)
    #   make_reservation_copies_match + "?reservation_id=#{reservation_id}"
    # end

  end


  module Reservation
    def self.uris(subpart)
      defs =  %Q{def #{subpart}_raw(interpolation)
                   "/2/reservations/\#{interpolation}/#{subpart}"
                 end
                 def #{subpart}_match
                   #{subpart}_raw(:reservation_id.inspect)
                 end
                 def #{subpart}_generator(reservation_id)
                   #{subpart}_raw(reservation_id)
                 end
               }
     instance_eval(defs)
    end

    uris("note")
    uris("repetitions")
  end

  # OLD
  def self.reservation_viewing_page(reservation_id)
    "/reservation/#{reservation_id}"
  end
end
