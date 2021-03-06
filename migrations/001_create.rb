class Creation < Sequel::Migration

  def up
    puts "==== Creating tables"
    DB.create_table :procedures do
      primary_key :id
      String :name
      int :days_delay
    end

    DB.create_table :animals do
      primary_key :id
      String :name
      String :nickname
      String :kind
    end

    DB.create_table :reservations do 
      primary_key :id
      Date :date
      boolean :morning
      String :course
      String :instructor
    end

    DB.create_table :groups do
      primary_key :id
      foreign_key :reservation_id, :reservations
    end

    DB.create_table :uses do
      primary_key :id
      foreign_key :procedure_id, :procedures
      foreign_key :animal_id, :animals
      foreign_key :group_id, :groups
    end

    DB.create_view(:expanded_uses,
                   DB[:procedures, :animals, :uses, :groups, :reservations].
                   filter(:procedures__id => :uses__procedure_id).
                   filter(:animals__id => :uses__animal_id).
                   filter(:groups__id => :uses__group_id).
                   filter(:reservations__id => :groups__reservation_id).
                   select(:procedures__name.as(:procedure_name),
                          :animals__name.as(:animal_name),
                          :reservations__date.as(:reservation_date),
                          :procedures__days_delay.as(:days_delay),
                          :reservations__morning.as(:reservation_morning),
                          (:reservations__date - :procedures__days_delay + 1).as(:first_excluded_date),
                          (:reservations__date + :procedures__days_delay).as(:first_available_date)))
    

    DB.create_table :authorizations do
      primary_key :id
      String :magic_word
    end
  end

  def down
    puts "==== Dropping all tables"
    DB.drop_table :procedures
    DB.drop_table :animals
    DB.drop_table :uses
    DB.drop_table :reservations
    DB.drop_table :authorizations
    DB.drop_table :groups
  end
end
