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

  DB.create_table! :uses do
    primary_key :id
    int :procedure_id
    int :animal_id
    Date :date
  end

end

def drop_tables
  DB.drop_table :procedures
  DB.drop_table :animals
  DB.drop_table :uses
end


def empty_tables
  DB[:procedures].delete
  DB[:animals].delete
  DB[:uses].delete
end
