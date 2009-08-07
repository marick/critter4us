def create(klass, *names)
  names.collect do | name |
    klass.create(:name => name)
  end
end


