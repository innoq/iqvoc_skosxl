class AddLabelRelations < ActiveRecord::Migration[4.2]
  def self.up
    unless table_exists?('label_relations')
      create_table 'label_relations', force: true do |t|
        t.string   'type'
        t.integer  'domain_id'
        t.integer  'range_id'
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end

      add_index 'label_relations', ['domain_id', 'range_id', 'type'], name: 'ix_label_rel_dom_rng_type'
      add_index 'label_relations', ['type'], name: 'ix_label_relations_on_type'
    end
  end

  def self.down
    if table_exists?('label_relations')
      drop_table('label_relations')
    end
  end
end
