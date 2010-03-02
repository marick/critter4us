class ReservationStructureChanger

  attr_reader :reservation

  def self.build_from(data)
    instance = new(data)
    instance.create_with_direct_data
    instance.add_groups
    instance.reservation
  end

  def initialize(data)
    @reservation_part, @data_for_each_group = partition_reservation_data(data)
  end

  def create_with_direct_data
    @reservation = Reservation.create(@reservation_part)
  end

  def update_direct_data
    @reservation.update(@reservation_part)
  end

  def use_reservation(reservation)
    @reservation = reservation
  end

  def destroy_groups
    @reservation.groups.each do | g |
      g.destroy
    end
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
    data_for_each_group = data.delete(:groups)
    make_time_sets_into_booleans(data)
    make_unspecified_time_segments_explicit(data)
    [data, data_for_each_group]
  end

  def make_time_sets_into_booleans(data)
    times = data.delete(:times)
    return unless times
    data[:morning] = times.include?(MORNING)
    data[:afternoon] = times.include?(AFTERNOON)
    data[:evening] = times.include?(EVENING)
  end

  def make_unspecified_time_segments_explicit(data)
    [:morning, :afternoon, :evening].each do | tag | 
      data[tag] ||= false
    end
  end

  def build_use(group, procedure_name, animal_name)
    procedure = Procedure[:name => procedure_name]
    animal = Animal[:name => animal_name]
    Use.create(:procedure => procedure,
               :animal => animal,
               :group => group)
  end
end
