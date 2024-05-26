module Forecasts
  InvalidAddress = Class.new(StandardError)

  Address = Struct.new(:street, :city, :state, :zipcode, :country, keyword_init: true) do

    def self.of(address)
      address ||= ""
      street, city, state, zipcode, country = address.split(/,/).map(&:strip).map(&:downcase)
      raise InvalidAddress.new("The address is invalid, please correct it") unless street && city && state && zipcode && country
      new(street: street, city: city, state: state, zipcode: zipcode, country: country)
    end

    def formatted
      "#{street}, #{city}, #{state}, #{zipcode}, #{country}".titleize
    end
  end
end
