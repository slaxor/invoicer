object current_user
attributes :avatar_filename, :email, :encrypted_password, :login
child :invoices do
  attributes :currency, :due_on, :history, :customer_id, :invoicing_party_id, :number, :purchase_order, :covering_text, :workflow_state
  child :invoice_items do
    attributes :pricing_strategy, :description, :started_at, :ended_at, :price, :vat_rate
    child :pauses do
      attributes :description, :started_at, :ended_at
    end
  end
end

