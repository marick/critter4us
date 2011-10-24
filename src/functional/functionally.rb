class Functionally
end

#   def corresponding_to(reservation_id)
#     r = DB[:reservations].filter(:id => reservation_id).first
#     g = DB[:groups].filter(:reservation_id => r.id).all
#     columns = [:animals__name.as(:animal_name)] + DB[:uses].columns
#     u = DB[:uses].join(:animals, :animals__id => :uses__animal_id).
#                   join(:procedures, :procedures__id => :uses__procedure_id).
#                   filter(:group_id => g.map(&:id)).
#                   select(:animals__name.as(:animal_name),
#                          :procedures__name.as(:procedure_name),
#                          :procedure_id, :animal_id, :group_id,
#                          :uses__id)
#     {:data => r, :groups => g, :uses => u}
#   end

#   # def without_key(hash, key)
#   #   retval = hash.dup
#   #   retval.delete(key)
#   #   retval
#   # end

#   # def without_id(hash)
#   #   without_key(hash, :id)
#   # end

#   # def copy_of(reservation_id)
#   #   r = full_reservation(reservation_id)
#   #   { :data => without_id(r.data),
#   #     :groups => r.groups.collect { | g | without_id(g) },
#   #     :uses => r.uses.collect { | g | without_id(g) }
#   #   }
#   # end

#   def insert_returning_id(full_reservation)
#     new_id = DB[:reservations].insert(full_reservation.data)
#     puts r.inspect
#     full_groups = full_reservation.groups.collect { | g | g.merge(:reservation_id => r.id) }
#     puts full_groups
#     g = DB[:groups].returning.insert_multiple(full_groups)
#     puts g
# #    puts DB[:reservations].all
#   end

    
    
#   def shift_to_timeslice(reservation_id, timeslice)
#     snapshot(corresponding_to(reservation_id))
#     # new_reservation, dropped_animal_names = corresponding_to(reservation_id).
#     #                                       with_timeslice(timeslice).
#     #                                       without_conflicting_animals
#     # return add_ids(new_reservation).id, dropped_animal_names
#   end
# end
