class CreateAlerts < ActiveRecord::Migration[6.0]
  def change
    create_table :alerts do |t|
      t.belongs_to :user, index: true
      t.string :currency_id, null: false
      t.decimal :target_price, null: false
      t.decimal :current_price, null: false
      t.string :status, null: false, default: "created"

      t.timestamps
    end
  end
end
