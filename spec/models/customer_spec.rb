require File.join(File.dirname(__FILE__),  '..', 'spec_helper')

describe Customer do
  describe 'associations' do
    it {
      should be_referenced_in :user
      should reference_many :invoices
    }
  end

  describe 'validations' do
    before do
      @customer = Factory(:random_customer)
    end

    it {
      should validate_uniqueness_of :name
    }
  end
end


