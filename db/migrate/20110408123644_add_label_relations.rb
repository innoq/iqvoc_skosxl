class AddLabelRelations < ActiveRecord::Migration[4.2]
  def up
    create_table :label_relations, force: true do |t|
      t.string   :type
      t.integer  :domain_id
      t.integer  :range_id
      t.timestamps
    end

    add_index 'label_relations', ['domain_id', 'range_id', 'type'], name: 'ix_label_rel_dom_rng_type'
    add_index 'label_relations', ['type'], name: 'ix_label_relations_on_type'
  end

  def down
    drop_table :label_relations
  end
end
