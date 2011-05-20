class InvoiceItem
  include Mongoid::Document
  embedded_in :invoice
  embeds_many :pauses, :dependent => :delete_all, :autosave => true

  field :description, :type => String
  field :started_at, :type => DateTime
  field :ended_at, :type => DateTime
  field :price, :type => Float #wir werden die rundungfehler sicher überleben und…
  field :pricing_strategy, :type => String, :default => 'hourly'
  field :vat_rate, :type => Float # …BigDecimal speichert als String was ich irgendwie hässlich find


  scope :default,  :order => :started_at

  accepts_nested_attributes_for :pauses, :allow_destroy => true

  def hours
    (ended_at - started_at) / 3600.0 - pause_length
  end

  def amount
    case pricing_strategy
    when 'fixed'
      price
    when 'hourly'
      price * hours
    else
      raise 'ImplementationWorkToDo'
    end
  end

  def vat_amount
    amount * vat_rate
  end

  def gross_amount
    amount + vat_amount
  end

  def pause_times
    pauses.map(&:to_s).join(', ')
  end

  def pause_length
    pauses.sum(&:length)
  end
end
