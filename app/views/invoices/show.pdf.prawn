#pdf.page.size = 'A4'
#pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
#pdf.font "/usr/share/fonts/truetype/msttcorefonts/georgia.ttf"
#pdf.font "Times-Roman"
pdf.font "Helvetica"
sender_address = [@invoice.invoicing_party.name, @invoice.invoicing_party.street, "#{@invoice.invoicing_party.post_code} #{@invoice.invoicing_party.city}"]
print_date = l(@invoice.printed_at.to_date)

pdf.bounding_box [pdf.margin_box.left, pdf.margin_box.top - 100], :width => 200 do
  pdf.text(format("%s | %s | %s %s",
      @invoice.invoicing_party.name,
      @invoice.invoicing_party.street,
      @invoice.invoicing_party.post_code,
      @invoice.invoicing_party.city), :size => 6)
  pdf.move_down 15
  pdf.text @invoice.customer.name
  pdf.text @invoice.customer.street
  pdf.move_down 10
  pdf.text "#{@invoice.customer.post_code} #{@invoice.customer.city}", :style => :bold
end

pdf.text_box("#{@invoice.invoicing_party.city}, #{print_date}",
    :at => [pdf.margin_box.left, pdf.cursor + pdf.font_size], :align => :right)

pdf.bounding_box [pdf.margin_box.left, pdf.cursor - 100], :width => pdf.margin_box.width do
  pdf.text t('invoicer.pdf.invoice'), :style => :bold, :size => 24
  pdf.text t('invoicer.pdf.invoice_number', {:number => @invoice.number}), :size => 14
end

pdf.bounding_box([pdf.margin_box.left, pdf.cursor - 50], :width => pdf.margin_box.width) do
  pdf.text t('invoicer.pdf.purchase_order', {:purchase_order => @invoice.purchase_order}) if @invoice.purchase_order
  pdf.text @invoice.covering_text
end
pdf.bounding_box [pdf.margin_box.left + 20, pdf.cursor - 30], :width => pdf.margin_box.width do
  pdf.table([
    [t('invoicer.pdf.hours_as_stated_in_service_statement', :hours => number_with_delimiter(@invoice.hours)),
       number_to_currency(@invoice.amount, :unit => @invoice.currency)],
    [t('invoicer.pdf.vat_to_be_added'),
      number_to_currency(@invoice.vat_amount, :unit => @invoice.currency)],
    [t('invoicer.pdf.total_amount'), number_to_currency(@invoice.gross_amount, :unit => @invoice.currency)]
  ], :cell_style => {:borders => []}) do
    row(-1).style(:font_style => :bold)
    column(1).align = :right
  end
end
pdf.bounding_box [pdf.margin_box.left, pdf.cursor - 30], :width => pdf.margin_box.width do
  pdf.text (t('invoicer.pdf.payment_until', {:due_on => l(@invoice.due_on.to_date)}))
end
# footer first page
pdf.bounding_box [pdf.margin_box.left, pdf.margin_box.bottom + 40 ], :width => pdf.margin_box.width do
  pdf.stroke_horizontal_rule
end

pdf.bounding_box([pdf.margin_box.left, pdf.margin_box.bottom + 70], :width => pdf.margin_box.width/3) do
  pdf.indent(50) do
    pdf.text(format("%s\n%s\n%s %s",
      @invoice.invoicing_party.name,
      @invoice.invoicing_party.street,
      @invoice.invoicing_party.post_code,
      @invoice.invoicing_party.city), :size => 7, :align => :left
    )
  end
end

pdf.bounding_box([pdf.margin_box.left + pdf.margin_box.width/3 + 5, pdf.margin_box.bottom + 30], :width => pdf.margin_box.width/3) do
  pdf.text(t('invoicer.pdf.tel_email_vatid',{:tel => @invoice.invoicing_party.telephone,
    :email => @invoice.invoicing_party.email,
    :vatid => @invoice.invoicing_party.vatid}), :size => 7, :align => :left
  )
end

pdf.bounding_box([pdf.margin_box.left + 2 * pdf.margin_box.width/3, pdf.margin_box.bottom + 30], :width => pdf.margin_box.width/3) do
  pdf.text(t('invoicer.pdf.bank_data',{:name => @invoice.invoicing_party.bank_name,
    :sort_code => @invoice.invoicing_party.bank_sort_code,
    :account => @invoice.invoicing_party.bank_account_number}), :size => 7, :align => :left
  )
end


pdf.start_new_page(:size => "A4", :layout => :landscape)
# header 2nd page
pdf.text_box(
  (sender_address + [@invoice.invoicing_party.telephone, @invoice.invoicing_party.email]).join(' | '),
  :at => [pdf.margin_box.left, pdf.margin_box.top + 15],
  :width => pdf.margin_box.width,
  :size => 8, :align => :right)
pdf.stroke_horizontal_rule

pdf.text_box(
  t('invoicer.pdf.service_statement_for_invoice', {:number => @invoice.number, :print_date => print_date}),
  :at => [pdf.margin_box.left, pdf.margin_box.top - 25],
  :width => pdf.margin_box.width,
  :size => 14, :align => :center, :style => :bold)

invoice_items = @invoice.invoice_items.map do |invoice_item|
  [
    l(invoice_item.started_at, :format => :numeric),
    l(invoice_item.ended_at, :format => :numeric),
    invoice_item.pause_times,
    number_with_delimiter(invoice_item.hours),
    invoice_item.description,
    number_to_currency(invoice_item.amount, :unit => @invoice.currency),
    number_with_delimiter(invoice_item.vat_rate * 100),
    number_to_currency(invoice_item.vat_amount, :unit => @invoice.currency),
    number_to_currency(invoice_item.gross_amount, :unit => @invoice.currency)
  ]
end
pdf.move_down 60
pdf.table(
  [['Anfang', 'Ende', 'Pausen', 'Stunden', 'Beschreibung', 'Betrag', 'Mwst.-Satz', 'Mwst.', 'Brutto']] + invoice_items,
  :cell_style => {:size => 6},
  :header => true,
  :row_colors => ["c0ffc0", "ffffff"]
) do
  columns(4).width = 300
  columns(3).align = :right
  columns(5..8).align = :right
  #column_min_widths = [80, 80, 100, 160, 50, 30, 30, 50, 50] #geht nicht
  row(0).style(:background_color => '404040', :text_color => 'ffffff', :size => 10)
  row(0).align = :center
end


