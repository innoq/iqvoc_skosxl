# encoding: UTF-8

require File.expand_path('../../test_helper', __FILE__)

class SkosExportTest < ActiveSupport::TestCase
  TEST_DATA = File.expand_path('../../fixtures/hobbies.nt', __FILE__)

  setup do
    @export_file = Rails.root.join('tmp', 'skos_export_test.nt').to_s
    @show_change_notes = Iqvoc.rdf_show_change_notes

    SkosImporter.new(File.open(TEST_DATA), 'http://hobbies.com/').run

    # the fixture holds too few labels to tell preloading from lazy loading
    @labels = 30.times.map do |i|
      label = Iqvoc::Xllabel.base_class.new(origin: "probe#{i}", value: "Probe #{i}", language: 'de')
      label.published_at = Time.now
      label.save!
      label
    end
    @labels.each_slice(2) do |domain, range|
      next unless range
      Label::Relation::Skosxl::Base.create!(domain: domain, range: range)
      Note::Skos::Definition.create!(owner: domain, value: "Definition #{domain.origin}", language: 'de')
    end
  end

  teardown do
    Iqvoc.rdf_show_change_notes = @show_change_notes
    File.delete(@export_file) if File.exist?(@export_file)
  end

  test 'label associations are loaded per batch instead of per label' do
    loads = count_loads

    ['Label::Relation::Base Load', 'Note::Base Load'].each do |name|
      assert_operator loads[name], :<, @labels.size,
          "expected '#{name}' to be preloaded, got #{loads[name]} queries for #{@labels.size} labels"
    end
  end

  # render_label_rdf only renders notes when change notes are shown, so
  # preloading them regardless would fetch and instantiate them for nothing.
  # Concepts load their notes either way, hence the comparison rather than an
  # absolute count.
  test 'notes are only preloaded when change notes are rendered' do
    Iqvoc.rdf_show_change_notes = true
    rendered = count_loads['Note::Base Load']

    Iqvoc.rdf_show_change_notes = false
    skipped = count_loads['Note::Base Load']

    assert_operator skipped, :<, rendered,
        'expected fewer note queries when change notes are not rendered'
  end

  private

  # runs an export and returns the number of queries per Active Record name
  def count_loads
    loads = Hash.new(0)
    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*, payload|
      loads[payload[:name].to_s] += 1
    end
    begin
      SkosExporter.new(@export_file, 'nt', 'http://hobbies.com/', Logger.new(IO::NULL)).run
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end
    loads
  end
end
