class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users , id: :uuid do |t|
      t.string :name, limit: 500

      t.integer :lock_version
      t.timestamps
    end
  end
end
