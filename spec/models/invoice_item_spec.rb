require File.join(File.dirname(__FILE__),  '..', 'spec_helper')

describe InvoiceItem do
  describe 'associations' do
    it {
      should be_embedded_in :invoice
      should embed_many :pauses
    }
  end

  before do
    @invoice_item = Factory(:random_invoice_item)
  end

  describe '#hours' do
    it 'should calculate the hours from start and end time' do
      time=Time.now
      invoice_item = Factory(:random_invoice_item, :started_at => time - 45.minutes, :ended_at => time + 45.minutes)
      invoice_item.hours.should == 1.5
    end

    it 'should calculate the hours from start and end time and consider pauses' do
      time=Time.now
      invoice_item = Factory(:random_invoice_item, :started_at => time - 45.minutes, :ended_at => time + 45.minutes, :pauses => [
        {:started_at => time - 15.minutes, :ended_at => time}, {:started_at => time, :ended_at => time + 15.minutes} ])
      invoice_item.hours.should == 1.0
    end
  end

  describe '#amount' do
    it 'should return the price if the pricing strategy is fixed' do
      invoice_item = Factory(:random_invoice_item, :pricing_strategy => 'fixed')
      invoice_item.amount.should == 123
    end

    it 'should return the price * hours if the pricing strategy is hourly' do
      invoice_item.amount.should == 984.0
    end
  end

  describe '#vat_amount' do
    it 'should return the amounts vat to add' do
      invoice_item = Factory(:random_invoice_item)
      invoice_item.vat_amount.should == 186.96
    end
  end

  describe '#gross_amount' do
    it 'should return the amount with added vat' do
      invoice_item = Factory(:random_invoice_item)
      invoice_item.gross_amount.should == 1170.96
    end
  end

  describe '#pause_times' do
    pending 'not yet written'
  end

  describe '#pause_length' do
    pending 'not yet written'
  end
end

