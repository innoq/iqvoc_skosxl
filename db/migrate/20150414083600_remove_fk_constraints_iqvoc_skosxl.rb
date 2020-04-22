class RemoveFkConstraintsIqvocSkosxl < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :labels, column: 'published_version_id'
  end
end
