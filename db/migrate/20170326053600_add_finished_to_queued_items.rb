class AddFinishedToQueuedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :queued_items, :finished, :boolean
  end
end
