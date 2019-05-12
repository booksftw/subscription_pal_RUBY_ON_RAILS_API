class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.date :PaymentDate
      t.references :subscription, foreign_key: true
      t.timestamps
    end
  end
end
