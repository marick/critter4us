require './test/testutil/fast-loading-requires'
require './src/views/localizers'
require 'ostruct'
require 'date'

class LocalizerTests < Test::Unit::TestCase

  should "be able to collect localizers" do
    Localizers.to_localize(:a_page,
                           -> data { data })
    assert { Localizers::ByPage[:a_page].size == 1 }
    assert { Localizers::ByPage[:a_page][0].("data") == "data" }
  end

  should "be able to invoke localizers on data" do 
    Localizers.to_localize(:a_page,
                           -> data do
                             { :a => data[:datum].downcase }
                           end,
                           -> data do
                             { :b => (data[:another] + 1).to_s }
                           end)
    actual = Localizers.locals_for_page(:a_page, :datum => "UP", :another => 1)
    assert { actual == {:a => "up", :b => "2" } }
  end

  should "be able to pass a reservation along for reservation_note_editor" do
    actual = Localizers.locals_for_page(:reservation__note_editor, :reservation => "data")
    assert { actual == {:reservation => "data" } } 
  end
  

  should "be able to localize reservation__repetition_adder" do
    relevant_bits = OpenStruct.new(:id => "id",
                                   :first_date => Date.new(2001, 1, 2))
    actual = Localizers.locals_for_page(:reservation__repetition_adder,
                                        :reservation => relevant_bits)
    assert { actual[:start_date] == relevant_bits.first_date }
    assert { actual[:reservation] == relevant_bits } 
    assert { actual[:rest_links] ==
             [ Href::Reservation.repetitions_link("id", "fulfillment") ] }
  end
end
