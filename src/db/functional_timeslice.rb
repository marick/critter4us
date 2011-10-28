require './src/functional/functional_hash'

class FunctionalTimeslice < FunctionalHash
  self.extend(FHUtil)

  def self.from_browser(raw_data)
    data = JSON.parse(Base64.decode64(raw_data))
    from_time_data(Date.parse(data['first_date']), Date.parse(data['last_date']),
                   TimeSet.new(data['times']).bits)
  end

  def self.from_reservation(reservation)
    from_time_data(reservation.data.first_date, reservation.data.last_date,
                   reservation.data.time_bits)
  end

  def self.from_time_data(first_date, last_date, time_bits)
    F(:first_date => first_date,
      :last_date => last_date,
      :time_bits => time_bits)
  end

end
