class Pause
  include Mongoid::Document

  embedded_in :invoice_item

  field :description, :type => String
  field :started_at, :type => DateTime
  field :ended_at, :type => DateTime

  def to_s
    "#{I18n.l(self.started_at, :format => :time )} - #{I18n.l(self.ended_at, :format => :time)}"
  end

  def duration
    (self.ended_at.to_f - self.started_at.to_f) / 3600
  end
end
