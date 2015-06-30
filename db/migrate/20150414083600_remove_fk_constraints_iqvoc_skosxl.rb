class RemoveFkConstraintsIqvocSkosxl < ActiveRecord::Migration
  def change
    if foreign_keys(:labels).detect {|fk| fk.column == 'published_version_id' }
      remove_foreign_key :labels, column: 'published_version_id'
    end
  end
end
