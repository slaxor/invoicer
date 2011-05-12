#!/usr/bin/env ruby
#
#
require 'ruby-debug'
require 'yaml'
file = 'db/data.yml'
io = File.open(file)
data = YAML.load(File.read(file))
@doc = {}
YAML.load_documents(io) do |ydoc|
  #@doc[ydoc.keys[0]] = ydoc.values
  ydoc.keys.each do |k|
    @doc[k] = ydoc.values
  end
end

def build_data(array, skip_cols = [], p = {})
  data = []
  process = Hash.new {lambda {|r| r}}.merge(p)
  array[0]['records'].each do |record|
    data << {}
    record.each_with_index do |r,i|
      column = array[0]['columns'][i]
      entry = process[column].call(r)
      (data.last[column] = entry) unless skip_cols.include?(column)
    end
  end
  data
end

invoice_id_mapper = {}
invoices = build_data(@doc['invoices'], ['paid'], 'invoicing_party_id' => lambda{|r| InvoicingParty.first.id}, 'customer_id' => lambda{|r| Customer.first.id}).map do |i|
  id = i.delete('id')
  invoice = Invoice.new(i.merge({workflow_state:'paid'}))
  invoice_id_mapper[id] = invoice.id
  invoice
end

invoice_item_id_mapper = {}
invoice_items = build_data(@doc['invoice_items'], ['currency']).map do |invoice_item|
  id = invoice_item.delete('id')
  invoice = invoices.select {|i| i['_id'] == invoice_id_mapper[invoice_item['invoice_id']]}[0]
  invoice.invoice_items << InvoiceItem.new(invoice_item.merge('invoice_id' => invoice_item_id_mapper[invoice_item['invoice_id']]))
  invoice_item_id_mapper[id] = invoice.invoice_items.last.id
  invoice_item
end

pauses =  build_data(@doc['pauses'], %w(id created_at updated_at )).map do |pause|
  invoice = invoices.select {|i| i.invoice_items.map(&:id).include?(invoice_item_id_mapper[pause['invoice_item_id']])}[0]
  invoice_item = invoice.invoice_items.select {|i| i['_id'] == invoice_item_id_mapper[pause['invoice_item_id']]}[0]
  invoice_item.pauses << Pause.new(pause.merge({:invoice_item_id => invoice_item_id_mapper[pause['invoice_item_id']]}))
end

invoices.each{ |i| i.save rescue puts i.id}

ip = build_data(@doc['invoicing_parties'])
build_data(@doc['invoices'], ['created_at', 'default_id', 'updated_at'], {'id' => lambda {|r| r.to_i}, 'customer_id' => lambda {|r| r.to_i}, 'invoicing_party_id' => lambda {|r| r.to_i}}).each do |i|
  Invoice.create(i)
end

debugger
''
