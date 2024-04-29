require 'rails_helper'

RSpec.describe Forecasts::Address do
  subject(:address) { described_class }

  describe '.of' do
    context 'when the address is invalid' do
      it 'throws an invalid address error' do
        expect { address.of('Calle 13') }.to raise_error(Forecasts::InvalidAddress)
      end
    end

    context 'when the address is empty' do
      it 'throws an invalid address error' do
        expect { address.of('') }.to raise_error(Forecasts::InvalidAddress)
      end
    end
  end

  describe '#formatted' do
    it 'returns a formatted address' do
      expect(
        address.of('Calle 13, Bogota, Cundinamarca, 110111, Colombia').formatted
      ).to eq('Calle 13, Bogota, Cundinamarca, 110111, Colombia')
    end
  end

end
