def create_tables

  DB.create_table! :procedures do
    primary_key :id
    String :name
    int :days_delay
  end

  DB.create_table! :animals do
    primary_key :id
    String :name
    String :kind
  end

  DB.create_table! :reservations do 
    primary_key :id
    Date :date
  end

  DB.create_table! :uses do
    primary_key :id
    foreign_key :procedure_id, :procedures
    foreign_key :animal_id, :animals
    foreign_key :reservation_id, :reservations
  end

end

def drop_tables
  DB.drop_table :procedures
  DB.drop_table :animals
  DB.drop_table :uses
  DB.drop_table :reservations
end


def empty_tables
  DB[:procedures].delete
  DB[:animals].delete
  DB[:uses].delete
  DB[:reservations].delete
end
