class ExtendLabel < ActiveRecord::Migration

  FIELDS = [
    {'rev' => {type: :integer, options: {default: 1}}},
    {'published_version_id' => {type: :integer}},
    {'published_at' => {type: :date}},
    {'locked_by' => {type: :integer}},
    {'expired_at' => {type: :date}},
    {'follow_up' => {type: :date}},
    {'to_review' => {type: :boolean}},
    {'rdf_updated_at' => {type: :date}}
  ]

  def self.up
    FIELDS.each do |hsh|
      hsh.each do |column_name, hsh2|
        unless column_exists?(:labels, column_name)
          add_column(:labels, column_name, hsh2[:type], (hsh2[:options] || {}))
        end
      end
    end

    add_index :labels, 'published_version_id', name: 'ix_labels_on_published_v' unless index_exists?(:labels, 'published_version_id', name: 'ix_labels_on_published_v')

  end

  def self.down
    FIELDS.each do |hsh|
      hsh.each do |column_name, hsh2|
        if column_exists?(:labels, column_name)
          remove_column(:labels, column_name)
        end
      end
    end
  end

end