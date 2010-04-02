$: << '../..' unless $in_rake
require 'test/testutil/requires'

class TakingOutOfServiceTestCase < EndToEndTestCase

  def setup
    super
    Procedure.random(:name => 'venipuncture')
    Procedure.random(:name => 'physical', :days_delay => 3)
    
    Animal.random(:name => 'veinie')
    Animal.random(:name => 'bossie')
    Animal.random(:name => 'staggers')

    make_reservation('2010-12-12', %w{veinie staggers}, %w{venipuncture})
    make_reservation('2009-01-01', %w{bossie}, %w{physical})
  end

  def get_animals_that_can_be_taken_out_of_service
    response = get('/json/animals_that_can_be_taken_out_of_service',
                   :date => '2009-01-02')

    assert_equal(['bossie'], unjsonify(response)['unused animals'])
  end

  def get_animals_with_pending_reservations
    response = get('/animals_with_pending_reservations', :date => '2009-01-02')
    assert_match(/staggers/, response.body)
    assert_match(/veinie/, response.body)
    assert_xhtml(response.body) do 
      a('2010-12-12')
    end
  end  

  def post_take_animals_out_of_service
    response = post('/json/take_animals_out_of_service', 
                    {:data => {
                        :animals => ['bossie'],
                        :date => '2009-06-06'
                      }.to_json})
  end

  def check_if_animal_in_service_before_out_of_service_date
    response = get('/json/animals_and_procedures_blob',
                   :timeslice => {
                     :firstDate => '2009-02-02', 
                     :lastDate => '2009-02-02',
                     :times => ['morning']
                   }.to_json)
    assert_equal(["bossie", "staggers", "veinie"], unjsonify(response)['animals'])
  end

  def check_if_animal_out_of_service_afterwards
    response = get('/json/animals_and_procedures_blob',
                   :timeslice => {
                     :firstDate => '2009-06-01', 
                     :lastDate => '2009-06-06',
                     :times => ['morning', 'evening']
                   }.to_json)
    assert_equal(["staggers", "veinie"], unjsonify(response)['animals'])
  end
  

  should "do end-to-end trip" do 
    get_animals_that_can_be_taken_out_of_service
    get_animals_with_pending_reservations

    post_take_animals_out_of_service
    check_if_animal_in_service_before_out_of_service_date
    check_if_animal_out_of_service_afterwards
  end
end
