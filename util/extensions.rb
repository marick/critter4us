class Hash
  def only_key
    to_a[0][0]
  end

  def only_value
    to_a[0][1]
  end
end
