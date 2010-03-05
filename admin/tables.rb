
def drop_tables
  DB.drop_table :exclusion_rules
  DB.drop_table :procedures
  DB.drop_table :animals
  DB.drop_table :uses
  DB.drop_table :reservations
  DB.drop_table :authorizations
  DB.drop_table :groups
  DB.drop_table :procedure_descriptions
end


def empty_tables
  DB[:excluded_because_of_blackout_period].delete
  DB[:excluded_because_in_use].delete
  DB[:exclusion_rules].delete
  DB[:procedure_descriptions].delete
  DB[:uses].delete
  DB[:animals].delete
  DB[:procedures].delete
  DB[:groups].delete
  DB[:reservations].delete
  DB[:authorizations].delete
end
