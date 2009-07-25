class Procedure  < Sequel::Model
  one_to_many :uses
end

class Animal < Sequel::Model
  one_to_many :uses
end

class Use < Sequel::Model
  many_to_one :procedure
  many_to_one :animal
end

