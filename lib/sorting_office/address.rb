module SortingOffice
  class Address

    attr_accessor :address, :postcode, :town, :locality, :street, :paon, :saon

    def initialize(address)
      @address = address
    end

    def parse
      get_postcode
      get_town
      get_street
      get_locality
      get_aon
    end

    def get_postcode
      @postcode = Postcode.calculate(@address)
      @address = @address.gsub(@postcode.name, "")
    end

    def get_town
      @town = Town.calculate(@address, @postcode)
      # Only remove the last instance of the town name (as the town name may be in the street too)
      @address = remove_element(@town) if @town
    end

    def get_street
      @street = Street.calculate(@address, @postcode)
      @address = remove_element(@street) if @street
    end

    def get_locality
      @locality = Locality.calculate(@address, @postcode)
      @address = remove_element(@locality) if @locality
    end

    def get_aon
      aons = []

      lines = @address.split(/\n|,|\s{2,}/)

      if lines.count > 1
        lines.each_with_index do |l, line_number|
          # Split up the line
          words = l.split(" ")
          words.each_with_index do |w, word_number|
            # Does anything start with a number?
            if w.match(/^[0-9]+/)
              aons << [
                line_number,
                word_number,
                l.strip
              ]
            end
          end
        end
      end

      # If no AONs have numbers, add the first line to the AON list
      if aons.count == 0
        @paon = lines.first.strip
      end

      # If there is only one AON found so far
      if aons.count == 1
        # Make the first AON found into the PAON
        @paon = aons.first.last

        # If the AON isn't on line 0 of the address, then there is a SAON before it
        if aons.first[0] != 0
          @saon = lines.first.last
        end
      elsif aons.count == 2 # If there is more than one AON
        # The PAON is the second AON we've found, for some reason
        @paon = aons[1].last
        @saon = aons[0].last
      end

    end

    private

      def remove_element(el)
        @address.reverse.sub(/#{el.name.reverse}/i, "").reverse
      end

  end
end
