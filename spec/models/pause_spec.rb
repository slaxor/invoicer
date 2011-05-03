require File.join(File.dirname(__FILE__),  '..', 'spec_helper')

describe Pause do
  describe 'associations' do
    it {
      should be_embedded_in :invoice_item
    }
  end
end

