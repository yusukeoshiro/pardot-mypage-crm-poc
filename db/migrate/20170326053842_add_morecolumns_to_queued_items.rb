class AddMorecolumnsToQueuedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :queued_items, :assignment_complete, :boolean
    add_column :queued_items, :form_handler_complete, :boolean
    add_column :queued_items, :contact_update_complete, :boolean
  end
end
