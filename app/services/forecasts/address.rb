module Forecasts
  Address = Struct.new(:street, :city, :state, :zipcode, :country, keyword_init: true) do
    def self.of(address)
      street, city, state, zipcode, country = address.split(/,/).map(&:strip).map(&:downcase)
      new(street: street, city: city, state: state, zipcode: zipcode, country: country)
    end

    def formatted
      "#{street}, #{city}, #{state}, #{zipcode}, #{country}"
    end
  end
end
