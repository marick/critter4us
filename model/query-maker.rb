class QueryMaker

  def animal_name__literal
    :animals__name.as(:animal_name)
  end

  def animal_kind__literal
    :animals__kind.as(:animal_kind)
  end

  def procedure_name__literal
    :procedures__name.as(:procedure_name)
  end

  def to_select_appropriate(*selection_codes, &block)
    to_plan_to_select_appropriate(*selection_codes, &block)
    run
  end

  def run
    # puts @query.sql
    @query.all
  end

  def to_plan_to_select_appropriate(*selection_codes, &block)
    add_filters(&block)
    add_selections(*selection_codes)
  end

  def add_filters(&block)
    @query = nil
    block.call(self)
  end

  def add_selections(*selection_codes)
    selections = selection_codes.collect { | selection_code |
      special_case = selection_code.to_s + "__literal"
      if respond_to?(special_case)
        self.send(special_case)
      else
        selection_code
      end
    }
    @query = @query.select(*selections)
  end

  def join_syms(first,  separator, second)
    (first.to_s + separator + second.to_s).to_sym
  end

  def qualified(table, column)
    join_syms(table, '__', column)
  end

  def syngular(symbol)
    symbol.to_s[0...-1].to_sym
  end

  def reorder(tables)
    tables.sort do | first, second| 
      if /excluded/ =~ first.to_s
        -1
      elsif /excluded/ =~ second.to_s
        1
      else
        0
      end
    end
  end

  def begin_with(*tables)
    tables = reorder(tables)
    exclusion_table = tables.first
    @query = DB[exclusion_table]
    tables[1..-1].each do | table | 
      foreign_key = join_syms(syngular(table), '_', :id)
      @query = @query.join(table, 
                           qualified(exclusion_table, foreign_key) => 
                           qualified(table, :id))
    end
  end

  def restrict_to_tuples_with_animals_ever_out_of_service
    @query = @query.filter("animals.date_removed_from_service IS NOT NULL")
  end

  def restrict_to_tuples_with_animals_not_removed_from_service
    @query = @query.filter("(animals.date_removed_from_service is NULL)")
  end

  def restrict_to_tuples_with_animals_out_of_service(timeslice)
    @query = @query.filter("(animals.date_removed_from_service <= DATE ?)",
                     timeslice.last_date.to_s)
  end

  def restrict_to_tuples_with_animals_in_use_during(timeslice)
    restrict_to_tuples_with_blackout_periods_overlapping(timeslice)
    @query = @query.filter("(B? & CAST(time_bits AS bit(3))) != B'000'", timeslice.time_bits)
  end

  def restrict_to_tuples_in_use_on_or_after(date)
    @query = @query.filter("last_date >= Date ?", date.to_s)
  end

  def restrict_to_tuples_with_blackout_periods_overlapping(timeslice)
    @query = @query.filter("(DATE ? <= last_date) AND (first_date <= DATE ?)",
                            timeslice.first_date.to_s, timeslice.last_date.to_s)
  end

  def to_s; @query.sql; end
end
