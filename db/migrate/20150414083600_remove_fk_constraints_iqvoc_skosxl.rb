class RemoveFkConstraintsIqvocSkosxl < ActiveRecord::Migration
  def change
    remove_foreign_key :labels, column: 'published_version_id'
  end
end
