require File.join(File.dirname(__FILE__),  '..', 'spec_helper')

describe InvoicingParty do
  describe 'associations' do
    it {
      should be_referenced_in :user
      should reference_many :invoices
    }
  end
end
