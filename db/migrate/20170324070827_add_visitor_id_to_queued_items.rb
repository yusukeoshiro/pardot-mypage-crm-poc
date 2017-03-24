class AddVisitorIdToQueuedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :queued_items, :visitor_id, :string
  end
end
