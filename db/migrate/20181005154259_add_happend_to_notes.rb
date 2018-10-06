class AddHappendToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :happend, :datetime
  end
end
