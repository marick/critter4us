class ReservationBase
  attr_reader :reservation

  def initialize(data)
    @reservation_part, @data_for_each_group = partition_reservation_data(data)
  end

  def add_groups
    @data_for_each_group.each do | group_data | 
      
      group = Group.create(:reservation => reservation)
      cross_product_of_procedures_and_animals(group, group_data)
    end
  end

  private

  def cross_product_of_procedures_and_animals(group, group_data)
    group_data[:procedures].each do | procedure_name | 
      group_data[:animals].each do | animal_name |
        build_use(group, procedure_name, animal_name)
      end
    end
  end

  def partition_reservation_data(data)
    data = data.dup
    data_for_each_group = data.delete(:groups) || []
    timeslice = data.delete(:timeslice)
    data[:first_date] = timeslice.first_date
    data[:last_date] = timeslice.last_date
    data[:times] = timeslice.times
    make_timeset_into_hash(data)
    make_hash_into_bitstring(data)
    [data, data_for_each_group]
  end

  def make_hash_into_bitstring(data)
    bitstring = (data.delete(:morning) ? "1" : "0") +
                (data.delete(:afternoon) ? "1" : "0") + 
                (data.delete(:evening) ? "1" : "0")
    data[:time_bits] = bitstring
  end

  def make_timeset_into_hash(data)
    timeset = data.delete(:times)
    return unless timeset
    
    data[:morning] = timeset.include?(MORNING)
    data[:afternoon] = timeset.include?(AFTERNOON)
    data[:evening] = timeset.include?(EVENING)
  end

  def build_use(group, procedure_name, animal_name)
    procedure = Procedure[:name => procedure_name]
    animal = Animal[:name => animal_name]
    Use.create(:procedure => procedure,
               :animal => animal,
               :group => group)
  end


end
