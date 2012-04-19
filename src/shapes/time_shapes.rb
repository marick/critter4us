module TimeslicedElementShaped
  def in_descending_date_order
    sorted = sort { | a, b | 
      if a.first_date == b.first_date
        compare_bitstrings(a.time_bits, b.time_bits)
      else
        -(a.first_date <=> b.first_date)
      end
    }
  end

  private

  # There must be a more clever way, but I don't see it.
  def compare_bitstrings(first, second)
    return 0 if (first == second)
    return -1 if (first.to_i == 0)
    return 1 if (second.to_i == 0)

    first, second = find_lit_bit(first, second)
    result = (first[0] <=> second[0])
    return -result unless result == 0
    
    compare_bitstrings(first[1..-1], second[1..-1])
  end

  def find_lit_bit(first, second)
    return first, second if first.empty?
    return first, second if first[0,1] == '1' or second[0,1] == '1'
    find_lit_bit(first[1..-1], second[1..-1])
  end



end
