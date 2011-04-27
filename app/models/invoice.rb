# -*- encoding : utf-8 -*-
class Invoice
  include Mongoid::Document

  referenced_in :customer
  referenced_in :invoicing_party
  embeds_many :invoice_items

  field :number, :type => String
  field :currency, :type => String
  field :covering_text, :type => String
  field :workflow_state, :type => String, :default => 'new'
  field :due_on, :type => Date
  field :history, :type => Array, :default => []

  attr_accessible :customer_id, :number, :currency, :covering_text, :invoicing_party_id, :workflow_state, :due_on, :printed_at,
    :invoice_items, :history

  include Workflow

  #workflow_column :status

  workflow do
    state :new do
      event :complete, :transitions_to => :completed
      event :cancel, :transitions_to => :cancelled
    end

    state :completed do
      event :print, :transitions_to => :printed
      event :cancel, :transitions_to => :cancelled
    end

    state :printed do
      event :issue, :transitions_to => :issued
      event :cancel, :transitions_to => :cancelled
    end

    state :issued do
      event :received_payment, :transitions_to => :paid
      event :cancel, :transitions_to => :cancelled
    end

    state :overdue do
      event :received_payment, :transitions_to => :paid
      event :remind, :transitions_to => :reminded
      event :cancel, :transitions_to => :cancelled
    end
    state :reminded do
      event :remind, :transitions_to => :reminded
      event :apply_for_court_order, :transitions_to => :applied_for_court_order
      event :received_payment, :transitions_to => :paid
      event :cancel, :transitions_to => :cancelled
    end

    # spätestens ab hier enstehen weitere kosten deshalb ist es fraglich ob die
    # jeweils aktuelle rechnung überhaupt weiterverfolgt werden kann oder ne neue
    # ausgestellt werden muss...
    state :applied_for_court_order do
      event :received_payment, :transitions_to => :paid
      event :won, :transitions_to => :summons_issued
      event :lost, :transitions_to => :unenforcable
    end

    state :summons_issued do
      event :received_payment, :transitions_to => :paid
      event :cancel, :transitions_to => :cancelled
      event :enforcable, :transitions_to => :enforcable
      event :unenforcable, :transitions_to => :unenforcable
    end

    state :paid_partially do
      #keine ahnung was ich damit mache
      #diese in diesem status lassen und ne neue ausstellen?
    end

    state :paid
    state :cancelled
    state :enforcable
    state :unenforcable

    on_transition do |from, to, triggering_event, *event_args|
      self.history << {from: from, to: to, triggering_event: triggering_event, when: Time.now}
    end
  end

  def set_default_number
    self.number = format('%s-%s%0.3i', customer.number, Time.now.to_s(:month_stamp), self.class.count(:conditions => {:customer_id => customer_id}))
  end

  def hours
    invoice_items.map(&:hours).sum
  end

  def amount
    invoice_items.map(&:amount).sum
  end

  def vat_amount
    invoice_items.map(&:vat_amount).sum
  end

  def gross_amount
    invoice_items.map(&:gross_amount).sum
  end
end

