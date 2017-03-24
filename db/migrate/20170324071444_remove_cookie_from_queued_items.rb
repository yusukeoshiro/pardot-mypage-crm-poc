class RemoveCookieFromQueuedItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :queued_items, :cookie, :string
  end
end
