class ChangeStatusToEnumInOrders < ActiveRecord::Migration[7.0]
  def up
    # Step 1: Add column allowing NULL first
    add_column :orders, :status_tmp, :integer, default: 0

    # Step 2: Map old string values to integer values
    status_mapping = {
      "pending" => 0,
      "accepted" => 1,
      "rejected" => 2,
      "in_progress" => 3,
      "completed" => 4
    }

    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_tmp, status_mapping[order.status] || 0)
    end

    # Step 3: Remove old string column
    remove_column :orders, :status

    # Step 4: Rename temp column to status
    rename_column :orders, :status_tmp, :status

    # Step 5: Enforce NOT NULL after data migration
    change_column_null :orders, :status, false
  end

  def down
    add_column :orders, :status_tmp, :string

    status_mapping = {
      0 => "pending",
      1 => "accepted",
      2 => "rejected",
      3 => "in_progress",
      4 => "completed"
    }

    Order.reset_column_information
    Order.find_each do |order|
      order.update_column(:status_tmp, status_mapping[order.status] || "pending")
    end

    remove_column :orders, :status
    rename_column :orders, :status_tmp, :status
  end
end


