require './src/functional/functional_hash'

class FunctionalTimeslice < FunctionalHash
  self.extend(FHUtil)

  def self.from_browser(raw_data)
    data = JSON.parse(Base64.decode64(raw_data))
    F(:first_date => Date.parse(data['first_date']),
      :last_date => Date.parse(data['last_date']),
      :time_bits => TimeSet.new(data['times']).bits)
  end

  def self.from_reservation(reservation)
    F(:first_date => reservation.data.first_date,
      :last_date => reservation.data.last_date,
      :time_bits => reservation.data.time_bits)
  end
end
