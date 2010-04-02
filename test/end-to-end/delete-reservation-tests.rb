$: << '../..' unless $in_rake
require 'test/testutil/requires'

class DeleteReservationTestCase < EndToEndTestCase

  def setup
    super
    Procedure.random(:name => 'venipuncture')
    Procedure.random(:name => 'physical', :days_delay => 3)
    
    Animal.random(:name => 'veinie')
    Animal.random(:name => 'bossie')
    Animal.random(:name => 'staggers')

    make_reservation('2010-12-12', %w{veinie staggers}, %w{venipuncture})
    make_reservation('2009-01-01', %w{bossie}, %w{physical})
    @reservation = Reservation[:first_date => Date.new(2009, 1, 1)]
  end

  def show_reservations
    get '/reservations'
    to_delete = /#{@reservation.id}/
    assert_xhtml(last_response.body) do 
      table do 
        td("staggers, veinie")
        td("bossie")
        form(:action => to_delete) do 
          input(:type => "submit", :value => "Delete")
        end
      end
    end
  end

  def choose_deletion
    delete("/reservation/#{@reservation.id}")
    follow_redirect!
    deny { /bossie/ =~ last_response.body }
    deny { Reservation[@reservation.id] }
  end

  def previously_reserved_animals_are_available_on_that_date
    get('/json/animals_and_procedures_blob',
                   :timeslice => {
                     :firstDate => '2009-01-01', 
                     :lastDate => '2010-12-12',
                     :times => ['morning', 'afternoon', 'evening']
                   }.to_json)
    assert_equal(["bossie"], unjsonify(last_response)['animals'])
  end
  

  should "do end-to-end trip" do 
    show_reservations
    choose_deletion
    previously_reserved_animals_are_available_on_that_date
  end
end
