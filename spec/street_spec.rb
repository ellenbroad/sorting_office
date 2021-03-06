require 'spec_helper'

describe Street do

  before(:each) do
    @postcode = FactoryGirl.create(:postcode, name: "EC2A 4JE", lat_lng: [51.522387, -0.083648])
    @street = FactoryGirl.create(:street, name: "CLIFTON STREET", lat_lng: [51.5224342908254, -0.08321407726274722])
    FactoryGirl.create(:street, name: "DYSART STREET", lat_lng: [51.52167440645816, -0.08403879963203438])
    FactoryGirl.create(:street, name: "PAUL STREET", lat_lng: [51.52300246620446, -0.08441551241348222])
  end

  it "detects a street" do
    address = "3rd Floor, 65 Clifton Street, London EC2A 4JE"

    street = Street.calculate(address, @postcode)

    expect(street).to eq(@street)
  end

  it "returns one street if there are two records with the same name in close proximity" do
    FactoryGirl.create(:street, name: "CLIFTON STREET", lat_lng: [51.5224342908258, -0.08321407726274730])
    address = "3rd Floor, 65 Clifton Street, London EC2A 4JE"

    street = Street.calculate(address, @postcode)

    expect(street).to eq(@street)
  end

  it "returns the correct street when the official street name has a special character" do
    s = FactoryGirl.create(:street, name: "ST JOHN'S ROAD", lat_lng: [51.5224342908258, -0.08321407726274730])
    address = "123 St Johns Road, London EC2A 4JE"

    street = Street.calculate(address, @postcode)

    expect(street).to eq(s)
  end

end
