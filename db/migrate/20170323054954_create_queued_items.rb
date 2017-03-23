class CreateQueuedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :queued_items do |t|
      t.string :email
      t.string :cookie

      t.timestamps
    end
  end
end
