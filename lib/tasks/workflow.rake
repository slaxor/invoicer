namespace :workflow do
  desc 'creates a fsm diagram for the invoice model'
  task :create_workflow_diagram => :environment do
    Workflow::create_workflow_diagram(Invoice)
  end

  desc 'sets overdue invoices to "overdue"'
  task :set_overdue => :environment do
    puts Invoice.find(:all, {'due_on.gt' => Date.today})
  end

end
