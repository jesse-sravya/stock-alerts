class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :role, default: 1, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
