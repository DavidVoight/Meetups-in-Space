class AddOwnerToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :owner, :boolean, null: false
  end
end
