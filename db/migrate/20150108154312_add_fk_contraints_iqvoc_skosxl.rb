class AddFkContraintsIqvocSkosxl < ActiveRecord::Migration
  def change
    add_foreign_key :labels, :labels, column: 'published_version_id', on_update: :cascade, on_delete: :cascade
    add_foreign_key :label_relations, :labels, column: 'domain_id', on_update: :cascade, on_delete: :cascade
    add_foreign_key :label_relations, :labels, column: 'range_id', on_update: :cascade, on_delete: :cascade
  end
end
