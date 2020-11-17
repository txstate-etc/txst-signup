class AddSessionsSpecificLocation < ActiveRecord::Migration
  def up
    add_column :sessions, :specific_location, :string, limit: 255, null: false, default: ''
  end

  def down
    remove_column :sessions, :specific_location
  end
end
