class RemoveLockedByForLabel < ActiveRecord::Migration[7.0]
  def change
    remove_column :labels, :locked_by
  end
end
