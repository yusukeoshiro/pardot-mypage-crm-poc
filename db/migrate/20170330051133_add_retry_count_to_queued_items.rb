class AddRetryCountToQueuedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :queued_items, :retry_count, :integer
  end
end
