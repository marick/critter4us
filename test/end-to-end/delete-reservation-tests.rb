require './test/testutil/requires'

class DeleteReservationTestCase < EndToEndTestCase

  def setup
    super
    Procedure.random(:name => 'venipuncture')
    Procedure.random(:name => 'physical', :days_delay => 3)
    
    Animal.random(:name => 'veinie')
    Animal.random(:name => 'bossie')
    Animal.random(:name => 'staggers')

    @today = Date.today
    @later = @today + 12

    make_reservation(@later, %w{veinie staggers}, %w{venipuncture})
    make_reservation(@today, %w{bossie}, %w{physical})
    @reservation = Reservation[:first_date => @today]
  end

  def show_reservations
    get '/reservations/all'
    to_delete = /#{@reservation.id}/

    # TODO: These checks are less specific than the assert_xhtml one
    # below.
    assert_body_has_selector('td', :text => "staggers, veinie")
    assert_body_has_selector('td', :text => "bossie")
    assert_body_has_attributes('form', :action => to_delete)
    # assert_xhtml(last_response.body) do 
    #   table do 
    #     td("staggers, veinie")
    #     td("bossie")
    #     form(:action => to_delete) do 
    #       input(:type => "submit", :value => "Delete")
    #     end
    #   end
    # end
  end

  def choose_deletion
    delete("/reservation/#{@reservation.id}/days_to_display_after_deletion")
    follow_redirect!
    deny { /bossie/ =~ last_response.body }
    deny { Reservation[@reservation.id] }
  end

  def previously_reserved_animals_are_available_on_that_date
    get('/json/animals_and_procedures_blob',
                   :timeslice => {
                     :firstDate => @today.to_s, 
                     :lastDate => @later.to_s,
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
