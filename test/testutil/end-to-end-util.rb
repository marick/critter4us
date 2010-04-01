class EndToEndTestCase

  def make_reservation(date, animals, procedures)
    data = {
      'firstDate' => date,
      'lastDate' => date,
      'times' => [MORNING],
      'instructor' => 'morin',
      'course' => 'vm333',
      'groups' => [ {'procedures' => procedures,
                      'animals' => animals} ]
      }.to_json
    
    reservation_id(post('/json/store_reservation', :data => data))
  end

  def reservation_id(response)
    unjsonify(response)['reservation'].to_i
  end

  def unjsonify(response)
    JSON[response.body]
  end
end
