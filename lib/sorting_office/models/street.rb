class Street

  def self.calculate(address, postcode)
    nearby_streets = where({
      "lat_lng" => {
        "$near" => postcode.lat_lng.to_a,
        "$maxDistance" => 0.001262 # Roughly 5 miles
      }
    })

    matches = []

    nearby_streets.each do |street|
      matches << street if address.match(/#{street.name}/i)
    end

    if matches.count == 1
      return matches.first
    end
  end

end
