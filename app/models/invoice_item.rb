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
    (self.ended_at.to_f - self.started_at.to_f) / 3600.0 - self.pause_duration
  end

  def amount
    case pricing_strategy
    when 'fixed'
      self.price
    when 'hourly'
      self.price * self.hours
    else
      raise 'ImplementationWorkToDo'
    end
  end

  def vat_amount
    self.amount * self.vat_rate
  end

  def gross_amount
    self.amount + self.vat_amount
  end

  def pause_times
    self.pauses.map(&:to_s).join(', ')
  end

  def pause_duration
    self.pauses.to_a.sum(&:duration)
  end
end
