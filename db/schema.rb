# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130315141952) do

  create_table "collection_members", :force => true do |t|
    t.integer "collection_id"
    t.integer "target_id"
    t.string  "type"
  end

  add_index "collection_members", ["collection_id", "target_id", "type"], :name => "ix_collections_fk_type"

  create_table "concept_relations", :force => true do |t|
    t.string   "type"
    t.integer  "owner_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",       :default => 100
  end

  add_index "concept_relations", ["owner_id", "target_id"], :name => "ix_concept_relations_fk"

  create_table "concepts", :force => true do |t|
    t.string   "type"
    t.string   "origin",               :limit => 4000
    t.integer  "rev",                                  :default => 1
    t.date     "published_at"
    t.integer  "published_version_id"
    t.integer  "locked_by"
    t.date     "expired_at"
    t.date     "follow_up"
    t.boolean  "to_review"
    t.date     "rdf_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "top_term",                             :default => false
  end

  add_index "concepts", ["origin"], :name => "ix_concepts_on_origin"
  add_index "concepts", ["published_version_id"], :name => "ix_concepts_publ_version_id"

  create_table "configuration_settings", :force => true do |t|
    t.string "key"
    t.string "value"
  end

  create_table "label_relations", :force => true do |t|
    t.string   "type"
    t.integer  "domain_id"
    t.integer  "range_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "label_relations", ["domain_id", "range_id", "type"], :name => "ix_label_rel_dom_rng_type"
  add_index "label_relations", ["type"], :name => "ix_label_relations_on_type"

  create_table "labelings", :force => true do |t|
    t.string   "type"
    t.integer  "owner_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labelings", ["owner_id", "target_id", "type"], :name => "ix_labelings_fk_type"
  add_index "labelings", ["type"], :name => "ix_labelings_on_type"

  create_table "labels", :force => true do |t|
    t.string   "type"
    t.string   "origin",               :limit => 4000
    t.string   "language"
    t.string   "value",                :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rev",                                  :default => 1
    t.integer  "published_version_id"
    t.date     "published_at"
    t.integer  "locked_by"
    t.date     "expired_at"
    t.date     "follow_up"
    t.boolean  "to_review"
    t.date     "rdf_updated_at"
  end

  add_index "labels", ["language"], :name => "ix_labels_on_language"
  add_index "labels", ["origin"], :name => "ix_labels_on_origin"
  add_index "labels", ["published_version_id"], :name => "ix_labels_on_published_v"
  add_index "labels", ["value"], :name => "ix_labels_on_value"

  create_table "matches", :force => true do |t|
    t.integer  "concept_id"
    t.string   "type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["concept_id", "type"], :name => "ix_matches_fk_type"
  add_index "matches", ["type"], :name => "ix_matches_on_type"

  create_table "notations", :force => true do |t|
    t.integer "concept_id"
    t.string  "value",      :limit => 4000
    t.string  "data_type",  :limit => 4000
  end

  add_index "notations", ["concept_id"], :name => "index_notations_on_concept_id"

  create_table "note_annotations", :force => true do |t|
    t.integer  "note_id"
    t.string   "predicate",  :limit => 50
    t.string   "value",      :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace",  :limit => 50
  end

  add_index "note_annotations", ["note_id"], :name => "ix_note_annotations_fk"

  create_table "notes", :force => true do |t|
    t.string   "language",   :limit => 2
    t.string   "value",      :limit => 4000
    t.string   "type",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type",                 :null => false
  end

  add_index "notes", ["language"], :name => "ix_notes_on_language"
  add_index "notes", ["owner_id", "owner_type", "type"], :name => "ix_notes_fk_type"
  add_index "notes", ["type"], :name => "ix_notes_on_type"

  create_table "users", :force => true do |t|
    t.string   "forename"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.string   "role"
    t.string   "telephone_number"
  end

end
