class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|

    t.timestamps
    t.string :name
    t.integer :amount
    end
  end
end
