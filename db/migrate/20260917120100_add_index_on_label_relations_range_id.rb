class AddIndexOnLabelRelationsRangeId < ActiveRecord::Migration[8.1]
  def change
    add_index :label_relations, :range_id
  end
end
