class Pause
  include Mongoid::Document

  embedded_in:service_invoice_item

  field :description, :type => String
  field :started_at, :type => DateTime
  field :ended_at, :type => DateTime

  def to_s
    "#{started_at.to_s(:time)} - #{ended_at.to_s(:time)}"
  end

  def length
    (ended_at - started_at) / 3600
  end
end
