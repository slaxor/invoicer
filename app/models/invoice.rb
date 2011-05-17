# -*- encoding : utf-8 -*-
class Invoice
  include Mongoid::Document

  referenced_in :customer
  referenced_in :invoicing_party
  embeds_many :invoice_items

  field :number, :type => String
  field :purchase_order, :type => String
  field :currency, :type => String, :default => '€'
  field :covering_text, :type => String
  field :workflow_state, :type => String, :default => 'started'
  field :due_on, :type => Date, :default => 4.weeks.from_now.to_date
  field :history, :type => Array, :default => []


  attr_accessible :customer_id, :number, :purchase_order, :currency, :covering_text, :invoicing_party_id, :workflow_state, :due_on,
    :invoice_items, :history

  default_scope desc(:due_on)

  validates_uniqueness_of :number, :scope => :invoicing_party_id
  validate :invoicing_party_id do |i|
    i.invoicing_party_id.is_a?(BSON::ObjectId)
  end

  validate :customer_id do

    self.is_a?(BSON::ObjectId)
  end

  include Workflow

  workflow do
    state :started do
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
      event :received_partial_payment, :transitions_to => :paid_partially
      event :cancel, :transitions_to => :cancelled
      event :due_date_exceeded, :transitions_to => :overdue
    end

    state :overdue do
      event :received_payment, :transitions_to => :paid
      event :received_partial_payment, :transitions_to => :paid_partially
      event :remind, :transitions_to => :reminded
      event :cancel, :transitions_to => :cancelled
    end

    state :reminded do
      event :remind, :transitions_to => :reminded
      event :apply_for_court_order, :transitions_to => :applied_for_court_order
      event :received_payment, :transitions_to => :paid
      event :received_partial_payment, :transitions_to => :paid_partially
      event :cancel, :transitions_to => :cancelled
    end

    # spätestens ab hier enstehen weitere kosten deshalb ist es fraglich ob die
    # jeweils aktuelle rechnung überhaupt weiterverfolgt werden kann oder ne neue
    # ausgestellt werden muss...
    state :applied_for_court_order do
      event :received_payment, :transitions_to => :paid
      event :received_partial_payment, :transitions_to => :paid_partially
      event :won, :transitions_to => :summons_issued
      event :lost, :transitions_to => :unenforcable
    end

    state :summons_issued do
      event :received_payment, :transitions_to => :paid
      event :received_partial_payment, :transitions_to => :paid_partially
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

  after_initialize :set_overdue_if

  def user
    self.customer.user
  end

  def set_overdue_if
    self.due_date_exceeded! if (issued? && due_on.to_date < Date.today)
  end

  def hours
    invoice_items.sum(&:hours)
  end

  def amount
    invoice_items.sum(&:amount)
  end

  def vat_amount
    invoice_items.sum(&:vat_amount)
  end

  def gross_amount
    invoice_items.sum(&:gross_amount)
  end

  def printed_at
    (self.history.detect {|record| record['to'] == :printed} || {'when' => Time.now})['when']
  end
end

