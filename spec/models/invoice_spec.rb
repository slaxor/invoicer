require File.join(File.dirname(__FILE__),  '..', 'spec_helper')

describe Invoice do
  describe 'associations' do
    it {
      should be_referenced_in :invoicing_party
      should embed_many :invoice_items
    }
  end

  describe 'workflow' do
    before do
      @invoice = Factory(:random_invoice)
    end

    it 'should start with the workflow_state "new"' do
      @invoice.new?.should be_true
    end

    it 'should have events complete, print, issue and receive_payment with appropriate states' do
      @invoice.complete!
      @invoice.completed?.should be_true
      @invoice.print!
      @invoice.printed?.should be_true
      @invoice.issue!
      @invoice.issued?.should be_true
      @invoice.received_payment!
      @invoice.paid?.should be_true
    end

    it 'should autotacally become overdue if due_on has passed' do
      Factory(:random_invoice, :due_on => Date.today - 1.day, :workflow_state => 'issued')
      invoice = Invoice.last
      invoice.overdue?.should be_true
    end

    pending 'lots to do'
  end

end

