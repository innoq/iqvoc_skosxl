# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class LabelsOrderTest < ActionDispatch::IntegrationTest

  test 'label order is not case-sensitive' do
    names = ['aaa', 'bbb', 'abc', 'ABC']
    lang = 'en'
    # create a few labels
    names.each_with_index do |name, index|
      label = Label::SKOSXL::Base.create! do |l|
        l.origin = "#{name}-#{index}"
        l.value = name
        l.language = lang
        l.published_at = Time.now
      end
    end
    assert_equal names.length, Label::Base.all.count # just to avoid confusion

    get labels_path(:lang => lang, :format => 'json')
    data = JSON.parse(@response.body)

    assert_response :success
    assert_equal 'aaa', data[0]['name']
    assert_equal 'abc', data[1]['name']
    assert_equal 'ABC', data[2]['name'] # XXX: do we care about order of "ABC" vs. "abc"?
    assert_equal 'bbb', data[3]['name']
  end

end
