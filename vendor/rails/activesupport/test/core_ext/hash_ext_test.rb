require 'abstract_unit'

class HashExtTest < Test::Unit::TestCase
  def setup
    @strings = { 'a' => 1, 'b' => 2 }
    @symbols = { :a  => 1, :b  => 2 }
    @mixed   = { :a  => 1, 'b' => 2 }
    @fixnums = {  0  => 1,  1  => 2 }
    if RUBY_VERSION < '1.9.0'
      @illegal_symbols = { "\0" => 1, "" => 2, [] => 3 }
    else
      @illegal_symbols = { [] => 3 }
    end
  end

  def test_methods
    h = {}
    assert_respond_to h, :symbolize_keys
    assert_respond_to h, :symbolize_keys!
    assert_respond_to h, :stringify_keys
    assert_respond_to h, :stringify_keys!
    assert_respond_to h, :to_options
    assert_respond_to h, :to_options!
  end

  def test_symbolize_keys
    assert_equal @symbols, @symbols.symbolize_keys
    assert_equal @symbols, @strings.symbolize_keys
    assert_equal @symbols, @mixed.symbolize_keys
  end

  def test_symbolize_keys!
    assert_equal @symbols, @symbols.dup.symbolize_keys!
    assert_equal @symbols, @strings.dup.symbolize_keys!
    assert_equal @symbols, @mixed.dup.symbolize_keys!
  end

  def test_symbolize_keys_preserves_keys_that_cant_be_symbolized
    assert_equal @illegal_symbols, @illegal_symbols.symbolize_keys
    assert_equal @illegal_symbols, @illegal_symbols.dup.symbolize_keys!
  end

  def test_symbolize_keys_preserves_fixnum_keys
    assert_equal @fixnums, @fixnums.symbolize_keys
    assert_equal @fixnums, @fixnums.dup.symbolize_keys!
  end

  def test_stringify_keys
    assert_equal @strings, @symbols.stringify_keys
    assert_equal @strings, @strings.stringify_keys
    assert_equal @strings, @mixed.stringify_keys
  end

  def test_stringify_keys!
    assert_equal @strings, @symbols.dup.stringify_keys!
    assert_equal @strings, @strings.dup.stringify_keys!
    assert_equal @strings, @mixed.dup.stringify_keys!
  end

  def test_indifferent_assorted
    @strings = @strings.with_indifferent_access
    @symbols = @symbols.with_indifferent_access
    @mixed   = @mixed.with_indifferent_access

    assert_equal 'a', @strings.send!(:convert_key, :a)

    assert_equal 1, @strings.fetch('a')
    assert_equal 1, @strings.fetch(:a.to_s)
    assert_equal 1, @strings.fetch(:a)

    hashes = { :@strings => @strings, :@symbols => @symbols, :@mixed => @mixed }
    method_map = { :'[]' => 1, :fetch => 1, :values_at => [1],
      :has_key? => true, :include? => true, :key? => true,
      :member? => true }

    hashes.each do |name, hash|
      method_map.sort_by { |m| m.to_s }.each do |meth, expected|
        assert_equal(expected, hash.send!(meth, 'a'),
                     "Calling #{name}.#{meth} 'a'")
        assert_equal(expected, hash.send!(meth, :a),
                     "Calling #{name}.#{meth} :a")
      end
    end

    assert_equal [1, 2], @strings.values_at('a', 'b')
    assert_equal [1, 2], @strings.values_at(:a, :b)
    assert_equal [1, 2], @symbols.values_at('a', 'b')
    assert_equal [1, 2], @symbols.values_at(:a, :b)
    assert_equal [1, 2], @mixed.values_at('a', 'b')
    assert_equal [1, 2], @mixed.values_at(:a, :b)
  end

  def test_indifferent_reading
    hash = HashWithIndifferentAccess.new
    hash["a"] = 1
    hash["b"] = true
    hash["c"] = false
    hash["d"] = nil

    assert_equal 1, hash[:a]
    assert_equal true, hash[:b]
    assert_equal false, hash[:c]
    assert_equal nil, hash[:d]
    assert_equal nil, hash[:e]
  end

  def test_indifferent_reading_with_nonnil_default
    hash = HashWithIndifferentAccess.new(1)
    hash["a"] = 1
    hash["b"] = true
    hash["c"] = false
    hash["d"] = nil

    assert_equal 1, hash[:a]
    assert_equal true, hash[:b]
    assert_equal false, hash[:c]
    assert_equal nil, hash[:d]
    assert_equal 1, hash[:e]
  end

  def test_indifferent_writing
    hash = HashWithIndifferentAccess.new
    hash[:a] = 1
    hash['b'] = 2
    hash[3] = 3

    assert_equal hash['a'], 1
    assert_equal hash['b'], 2
    assert_equal hash[:a], 1
    assert_equal hash[:b], 2
    assert_equal hash[3], 3
  end

  def test_indifferent_update
    hash = HashWithIndifferentAccess.new
    hash[:a] = 'a'
    hash['b'] = 'b'

    updated_with_strings = hash.update(@strings)
    updated_with_symbols = hash.update(@symbols)
    updated_with_mixed = hash.update(@mixed)

    assert_equal updated_with_strings[:a], 1
    assert_equal updated_with_strings['a'], 1
    assert_equal updated_with_strings['b'], 2

    assert_equal updated_with_symbols[:a], 1
    assert_equal updated_with_symbols['b'], 2
    assert_equal updated_with_symbols[:b], 2

    assert_equal updated_with_mixed[:a], 1
    assert_equal updated_with_mixed['b'], 2

    assert [updated_with_strings, updated_with_symbols, updated_with_mixed].all? { |h| h.keys.size == 2 }
  end

  def test_indifferent_merging
    hash = HashWithIndifferentAccess.new
    hash[:a] = 'failure'
    hash['b'] = 'failure'

    other = { 'a' => 1, :b => 2 }

    merged = hash.merge(other)

    assert_equal HashWithIndifferentAccess, merged.class
    assert_equal 1, merged[:a]
    assert_equal 2, merged['b']

    hash.update(other)

    assert_equal 1, hash[:a]
    assert_equal 2, hash['b']
  end

  def test_indifferent_deleting
    get_hash = proc{ { :a => 'foo' }.with_indifferent_access }
    hash = get_hash.call
    assert_equal hash.delete(:a), 'foo'
    assert_equal hash.delete(:a), nil
    hash = get_hash.call
    assert_equal hash.delete('a'), 'foo'
    assert_equal hash.delete('a'), nil
  end

  def test_indifferent_to_hash
    # Should convert to a Hash with String keys.
    assert_equal @strings, @mixed.with_indifferent_access.to_hash

    # Should preserve the default value.
    mixed_with_default = @mixed.dup
    mixed_with_default.default = '1234'
    roundtrip = mixed_with_default.with_indifferent_access.to_hash
    assert_equal @strings, roundtrip
    assert_equal '1234', roundtrip.default
  end

  def test_indifferent_hash_with_array_of_hashes
    hash = { "urls" => { "url" => [ { "address" => "1" }, { "address" => "2" } ] }}.with_indifferent_access
    assert_equal "1", hash[:urls][:url].first[:address]
  end

  def test_stringify_and_symbolize_keys_on_indifferent_preserves_hash
    h = HashWithIndifferentAccess.new
    h[:first] = 1
    h.stringify_keys!
    assert_equal 1, h['first']
    h = HashWithIndifferentAccess.new
    h['first'] = 1
    h.symbolize_keys!
    assert_equal 1, h[:first]
  end

  def test_to_options_on_indifferent_preserves_hash
    h = HashWithIndifferentAccess.new
    h['first'] = 1
    h.to_options!
    assert_equal 1, h['first']
  end


  def test_indifferent_subhashes
    h = {'user' => {'id' => 5}}.with_indifferent_access
    ['user', :user].each {|user| [:id, 'id'].each {|id| assert_equal 5, h[user][id], "h[#{user.inspect}][#{id.inspect}] should be 5"}}

    h = {:user => {:id => 5}}.with_indifferent_access
    ['user', :user].each {|user| [:id, 'id'].each {|id| assert_equal 5, h[user][id], "h[#{user.inspect}][#{id.inspect}] should be 5"}}
  end

  def test_assert_valid_keys
    assert_nothing_raised do
      { :failure => "stuff", :funny => "business" }.assert_valid_keys([ :failure, :funny ])
      { :failure => "stuff", :funny => "business" }.assert_valid_keys(:failure, :funny)
    end

    assert_raises(ArgumentError, "Unknown key(s): failore") do
      { :failore => "stuff", :funny => "business" }.assert_valid_keys([ :failure, :funny ])
      { :failore => "stuff", :funny => "business" }.assert_valid_keys(:failure, :funny)
    end
  end

  def test_assorted_keys_not_stringified
    original = {Object.new => 2, 1 => 2, [] => true}
    indiff = original.with_indifferent_access
    assert(!indiff.keys.any? {|k| k.kind_of? String}, "A key was converted to a string!")
  end

  def test_reverse_merge
    defaults = { :a => "x", :b => "y", :c => 10 }.freeze
    options  = { :a => 1, :b => 2 }
    expected = { :a => 1, :b => 2, :c => 10 }

    # Should merge defaults into options, creating a new hash.
    assert_equal expected, options.reverse_merge(defaults)
    assert_not_equal expected, options

    # Should merge! defaults into options, replacing options.
    merged = options.dup
    assert_equal expected, merged.reverse_merge!(defaults)
    assert_equal expected, merged

    # Should be an alias for reverse_merge!
    merged = options.dup
    assert_equal expected, merged.reverse_update(defaults)
    assert_equal expected, merged
  end

  def test_diff
    assert_equal({ :a => 2 }, { :a => 2, :b => 5 }.diff({ :a => 1, :b => 5 }))
  end

  def test_slice
    original = { :a => 'x', :b => 'y', :c => 10 }
    expected = { :a => 'x', :b => 'y' }

    # Should return a new hash with only the given keys.
    assert_equal expected, original.slice(:a, :b)
    assert_not_equal expected, original

    # Should replace the hash with only the given keys.
    assert_equal expected, original.slice!(:a, :b)
    assert_equal expected, original
  end

  def test_indifferent_slice
    original = { :a => 'x', :b => 'y', :c => 10 }.with_indifferent_access
    expected = { :a => 'x', :b => 'y' }.with_indifferent_access

    [['a', 'b'], [:a, :b]].each do |keys|
      # Should return a new hash with only the given keys.
      assert_equal expected, original.slice(*keys), keys.inspect
      assert_not_equal expected, original

      # Should replace the hash with only the given keys.
      copy = original.dup
      assert_equal expected, copy.slice!(*keys)
      assert_equal expected, copy
    end
  end

  def test_except
    original = { :a => 'x', :b => 'y', :c => 10 }
    expected = { :a => 'x', :b => 'y' }

    # Should return a new hash with only the given keys.
    assert_equal expected, original.except(:c)
    assert_not_equal expected, original

    # Should replace the hash with only the given keys.
    assert_equal expected, original.except!(:c)
    assert_equal expected, original
  end
end

class IWriteMyOwnXML
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.level_one do
      xml.tag!(:second_level, 'content')
    end
  end
end

class HashToXmlTest < Test::Unit::TestCase
  def setup
    @xml_options = { :root => :person, :skip_instruct => true, :indent => 0 }
  end

  def test_one_level
    xml = { :name => "David", :street => "Paulina" }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street>Paulina</street>))
    assert xml.include?(%(<name>David</name>))
  end

  def test_one_level_dasherize_false
    xml = { :name => "David", :street_name => "Paulina" }.to_xml(@xml_options.merge(:dasherize => false))
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street_name>Paulina</street_name>))
    assert xml.include?(%(<name>David</name>))
  end

  def test_one_level_dasherize_true
    xml = { :name => "David", :street_name => "Paulina" }.to_xml(@xml_options.merge(:dasherize => true))
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street-name>Paulina</street-name>))
    assert xml.include?(%(<name>David</name>))
  end

  def test_one_level_with_types
    xml = { :name => "David", :street => "Paulina", :age => 26, :age_in_millis => 820497600000, :moved_on => Date.new(2005, 11, 15), :resident => :yes }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street>Paulina</street>))
    assert xml.include?(%(<name>David</name>))
    assert xml.include?(%(<age type="integer">26</age>))
    assert xml.include?(%(<age-in-millis type="integer">820497600000</age-in-millis>))
    assert xml.include?(%(<moved-on type="date">2005-11-15</moved-on>))
    assert xml.include?(%(<resident type="symbol">yes</resident>))
  end

  def test_one_level_with_nils
    xml = { :name => "David", :street => "Paulina", :age => nil }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street>Paulina</street>))
    assert xml.include?(%(<name>David</name>))
    assert xml.include?(%(<age nil="true"></age>))
  end

  def test_one_level_with_skipping_types
    xml = { :name => "David", :street => "Paulina", :age => nil }.to_xml(@xml_options.merge(:skip_types => true))
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street>Paulina</street>))
    assert xml.include?(%(<name>David</name>))
    assert xml.include?(%(<age nil="true"></age>))
  end

  def test_one_level_with_yielding
    xml = { :name => "David", :street => "Paulina" }.to_xml(@xml_options) do |x|
      x.creator("Rails")
    end

    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<street>Paulina</street>))
    assert xml.include?(%(<name>David</name>))
    assert xml.include?(%(<creator>Rails</creator>))
  end

  def test_two_levels
    xml = { :name => "David", :address => { :street => "Paulina" } }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<address><street>Paulina</street></address>))
    assert xml.include?(%(<name>David</name>))
  end

  def test_two_levels_with_second_level_overriding_to_xml
    xml = { :name => "David", :address => { :street => "Paulina" }, :child => IWriteMyOwnXML.new }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<address><street>Paulina</street></address>))
    assert xml.include?(%(<level_one><second_level>content</second_level></level_one>))
  end

  def test_two_levels_with_array
    xml = { :name => "David", :addresses => [{ :street => "Paulina" }, { :street => "Evergreen" }] }.to_xml(@xml_options)
    assert_equal "<person>", xml.first(8)
    assert xml.include?(%(<addresses type="array"><address>))
    assert xml.include?(%(<address><street>Paulina</street></address>))
    assert xml.include?(%(<address><street>Evergreen</street></address>))
    assert xml.include?(%(<name>David</name>))
  end

  def test_three_levels_with_array
    xml = { :name => "David", :addresses => [{ :streets => [ { :name => "Paulina" }, { :name => "Paulina" } ] } ] }.to_xml(@xml_options)
    assert xml.include?(%(<addresses type="array"><address><streets type="array"><street><name>))
  end

  def test_single_record_from_xml
    topic_xml = <<-EOT
      <topic>
        <title>The First Topic</title>
        <author-name>David</author-name>
        <id type="integer">1</id>
        <approved type="boolean"> true </approved>
        <replies-count type="integer">0</replies-count>
        <replies-close-in type="integer">2592000000</replies-close-in>
        <written-on type="date">2003-07-16</written-on>
        <viewed-at type="datetime">2003-07-16T09:28:00+0000</viewed-at>
        <content type="yaml">--- \n1: should be an integer\n:message: Have a nice day\narray: \n- should-have-dashes: true\n  should_have_underscores: true\n</content>
        <author-email-address>david@loudthinking.com</author-email-address>
        <parent-id></parent-id>
        <ad-revenue type="decimal">1.5</ad-revenue>
        <optimum-viewing-angle type="float">135</optimum-viewing-angle>
        <resident type="symbol">yes</resident>
      </topic>
    EOT

    expected_topic_hash = {
      :title => "The First Topic",
      :author_name => "David",
      :id => 1,
      :approved => true,
      :replies_count => 0,
      :replies_close_in => 2592000000,
      :written_on => Date.new(2003, 7, 16),
      :viewed_at => Time.utc(2003, 7, 16, 9, 28),
      :content => { :message => "Have a nice day", 1 => "should be an integer", "array" => [{ "should-have-dashes" => true, "should_have_underscores" => true }] },
      :author_email_address => "david@loudthinking.com",
      :parent_id => nil,
      :ad_revenue => BigDecimal("1.50"),
      :optimum_viewing_angle => 135.0,
      :resident => :yes
    }.stringify_keys

    assert_equal expected_topic_hash, Hash.from_xml(topic_xml)["topic"]
  end

  def test_single_record_from_xml_with_nil_values
    topic_xml = <<-EOT
      <topic>
        <title></title>
        <id type="integer"></id>
        <approved type="boolean"></approved>
        <written-on type="date"></written-on>
        <viewed-at type="datetime"></viewed-at>
        <content type="yaml"></content>
        <parent-id></parent-id>
      </topic>
    EOT

    expected_topic_hash = {
      :title      => nil,
      :id         => nil,
      :approved   => nil,
      :written_on => nil,
      :viewed_at  => nil,
      :content    => nil,
      :parent_id  => nil
    }.stringify_keys

    assert_equal expected_topic_hash, Hash.from_xml(topic_xml)["topic"]
  end

  def test_multiple_records_from_xml
    topics_xml = <<-EOT
      <topics type="array">
        <topic>
          <title>The First Topic</title>
          <author-name>David</author-name>
          <id type="integer">1</id>
          <approved type="boolean">false</approved>
          <replies-count type="integer">0</replies-count>
          <replies-close-in type="integer">2592000000</replies-close-in>
          <written-on type="date">2003-07-16</written-on>
          <viewed-at type="datetime">2003-07-16T09:28:00+0000</viewed-at>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id nil="true"></parent-id>
        </topic>
        <topic>
          <title>The Second Topic</title>
          <author-name>Jason</author-name>
          <id type="integer">1</id>
          <approved type="boolean">false</approved>
          <replies-count type="integer">0</replies-count>
          <replies-close-in type="integer">2592000000</replies-close-in>
          <written-on type="date">2003-07-16</written-on>
          <viewed-at type="datetime">2003-07-16T09:28:00+0000</viewed-at>
          <content>Have a nice day</content>
          <author-email-address>david@loudthinking.com</author-email-address>
          <parent-id></parent-id>
        </topic>
      </topics>
    EOT

    expected_topic_hash = {
      :title => "The First Topic",
      :author_name => "David",
      :id => 1,
      :approved => false,
      :replies_count => 0,
      :replies_close_in => 2592000000,
      :written_on => Date.new(2003, 7, 16),
      :viewed_at => Time.utc(2003, 7, 16, 9, 28),
      :content => "Have a nice day",
      :author_email_address => "david@loudthinking.com",
      :parent_id => nil
    }.stringify_keys

    assert_equal expected_topic_hash, Hash.from_xml(topics_xml)["topics"].first
  end

  def test_single_record_from_xml_with_attributes_other_than_type
    topic_xml = <<-EOT
    <rsp stat="ok">
      <photos page="1" pages="1" perpage="100" total="16">
        <photo id="175756086" owner="55569174@N00" secret="0279bf37a1" server="76" title="Colored Pencil PhotoBooth Fun" ispublic="1" isfriend="0" isfamily="0"/>
      </photos>
    </rsp>
    EOT

    expected_topic_hash = {
      :id => "175756086",
      :owner => "55569174@N00",
      :secret => "0279bf37a1",
      :server => "76",
      :title => "Colored Pencil PhotoBooth Fun",
      :ispublic => "1",
      :isfriend => "0",
      :isfamily => "0",
    }.stringify_keys

    assert_equal expected_topic_hash, Hash.from_xml(topic_xml)["rsp"]["photos"]["photo"]
  end

  def test_empty_array_from_xml
    blog_xml = <<-XML
      <blog>
        <posts type="array"></posts>
      </blog>
    XML
    expected_blog_hash = {"blog" => {"posts" => []}}
    assert_equal expected_blog_hash, Hash.from_xml(blog_xml)
  end

  def test_empty_array_with_whitespace_from_xml
    blog_xml = <<-XML
      <blog>
        <posts type="array">
        </posts>
      </blog>
    XML
    expected_blog_hash = {"blog" => {"posts" => []}}
    assert_equal expected_blog_hash, Hash.from_xml(blog_xml)
  end

  def test_array_with_one_entry_from_xml
    blog_xml = <<-XML
      <blog>
        <posts type="array">
          <post>a post</post>
        </posts>
      </blog>
    XML
    expected_blog_hash = {"blog" => {"posts" => ["a post"]}}
    assert_equal expected_blog_hash, Hash.from_xml(blog_xml)
  end

  def test_array_with_multiple_entries_from_xml
    blog_xml = <<-XML
      <blog>
        <posts type="array">
          <post>a post</post>
          <post>another post</post>
        </posts>
      </blog>
    XML
    expected_blog_hash = {"blog" => {"posts" => ["a post", "another post"]}}
    assert_equal expected_blog_hash, Hash.from_xml(blog_xml)
  end

  def test_file_from_xml
    blog_xml = <<-XML
      <blog>
        <logo type="file" name="logo.png" content_type="image/png">
        </logo>
      </blog>
    XML
    hash = Hash.from_xml(blog_xml)
    assert hash.has_key?('blog')
    assert hash['blog'].has_key?('logo')

    file = hash['blog']['logo']
    assert_equal 'logo.png', file.original_filename
    assert_equal 'image/png', file.content_type
  end

  def test_file_from_xml_with_defaults
    blog_xml = <<-XML
      <blog>
        <logo type="file">
        </logo>
      </blog>
    XML
    file = Hash.from_xml(blog_xml)['blog']['logo']
    assert_equal 'untitled', file.original_filename
    assert_equal 'application/octet-stream', file.content_type
  end

  def test_xsd_like_types_from_xml
    bacon_xml = <<-EOT
    <bacon>
      <weight type="double">0.5</weight>
      <price type="decimal">12.50</price>
      <chunky type="boolean"> 1 </chunky>
      <expires-at type="dateTime">2007-12-25T12:34:56+0000</expires-at>
      <notes type="string"></notes>
      <illustration type="base64Binary">YmFiZS5wbmc=</illustration>
    </bacon>
    EOT

    expected_bacon_hash = {
      :weight => 0.5,
      :chunky => true,
      :price => BigDecimal("12.50"),
      :expires_at => Time.utc(2007,12,25,12,34,56),
      :notes => "",
      :illustration => "babe.png"
    }.stringify_keys

    assert_equal expected_bacon_hash, Hash.from_xml(bacon_xml)["bacon"]
  end

  def test_type_trickles_through_when_unknown
    product_xml = <<-EOT
    <product>
      <weight type="double">0.5</weight>
      <image type="ProductImage"><filename>image.gif</filename></image>

    </product>
    EOT

    expected_product_hash = {
      :weight => 0.5,
      :image => {'type' => 'ProductImage', 'filename' => 'image.gif' },
    }.stringify_keys

    assert_equal expected_product_hash, Hash.from_xml(product_xml)["product"]
  end

  def test_should_use_default_value_for_unknown_key
    hash_wia = HashWithIndifferentAccess.new(3)
    assert_equal 3, hash_wia[:new_key]
  end

  def test_should_use_default_value_if_no_key_is_supplied
    hash_wia = HashWithIndifferentAccess.new(3)
    assert_equal 3, hash_wia.default
  end

  def test_should_nil_if_no_default_value_is_supplied
    hash_wia = HashWithIndifferentAccess.new
    assert_nil hash_wia.default
  end

  def test_should_copy_the_default_value_when_converting_to_hash_with_indifferent_access
    hash = Hash.new(3)
    hash_wia = hash.with_indifferent_access
    assert_equal 3, hash_wia.default
  end

  # The XML builder seems to fail miserably when trying to tag something
  # with the same name as a Kernel method (throw, test, loop, select ...)
  def test_kernel_method_names_to_xml
    hash     = { :throw => { :ball => 'red' } }
    expected = '<person><throw><ball>red</ball></throw></person>'

    assert_nothing_raised do
      assert_equal expected, hash.to_xml(@xml_options)
    end
  end

  def test_empty_string_works_for_typecast_xml_value
    assert_nothing_raised do
      Hash.send!(:typecast_xml_value, "")
    end
  end

  def test_escaping_to_xml
    hash = {
      :bare_string        => 'First & Last Name',
      :pre_escaped_string => 'First &amp; Last Name'
    }.stringify_keys

    expected_xml = '<person><bare-string>First &amp; Last Name</bare-string><pre-escaped-string>First &amp;amp; Last Name</pre-escaped-string></person>'
    assert_equal expected_xml, hash.to_xml(@xml_options)
  end

  def test_unescaping_from_xml
    xml_string = '<person><bare-string>First &amp; Last Name</bare-string><pre-escaped-string>First &amp;amp; Last Name</pre-escaped-string></person>'
    expected_hash = {
      :bare_string        => 'First & Last Name',
      :pre_escaped_string => 'First &amp; Last Name'
    }.stringify_keys
    assert_equal expected_hash, Hash.from_xml(xml_string)['person']
  end

  def test_roundtrip_to_xml_from_xml
    hash = {
      :bare_string        => 'First & Last Name',
      :pre_escaped_string => 'First &amp; Last Name'
    }.stringify_keys

    assert_equal hash, Hash.from_xml(hash.to_xml(@xml_options))['person']
  end

  def test_datetime_xml_type_with_utc_time
    alert_xml = <<-XML
      <alert>
        <alert_at type="datetime">2008-02-10T15:30:45Z</alert_at>
      </alert>
    XML
    alert_at = Hash.from_xml(alert_xml)['alert']['alert_at']
    assert alert_at.utc?
    assert_equal Time.utc(2008, 2, 10, 15, 30, 45), alert_at
  end

  def test_datetime_xml_type_with_non_utc_time
    alert_xml = <<-XML
      <alert>
        <alert_at type="datetime">2008-02-10T10:30:45-05:00</alert_at>
      </alert>
    XML
    alert_at = Hash.from_xml(alert_xml)['alert']['alert_at']
    assert alert_at.utc?
    assert_equal Time.utc(2008, 2, 10, 15, 30, 45), alert_at
  end

  def test_datetime_xml_type_with_far_future_date
    alert_xml = <<-XML
      <alert>
        <alert_at type="datetime">2050-02-10T15:30:45Z</alert_at>
      </alert>
    XML
    alert_at = Hash.from_xml(alert_xml)['alert']['alert_at']
    assert alert_at.utc?
    assert_equal 2050,  alert_at.year
    assert_equal 2,     alert_at.month
    assert_equal 10,    alert_at.day
    assert_equal 15,    alert_at.hour
    assert_equal 30,    alert_at.min
    assert_equal 45,    alert_at.sec
  end
end

class QueryTest < Test::Unit::TestCase
  def test_simple_conversion
    assert_query_equal 'a=10', :a => 10
  end

  def test_cgi_escaping
    assert_query_equal 'a%3Ab=c+d', 'a:b' => 'c d'
  end

  def test_nil_parameter_value
    empty = Object.new
    def empty.to_param; nil end
    assert_query_equal 'a=', 'a' => empty
  end

  def test_nested_conversion
    assert_query_equal 'person%5Blogin%5D=seckar&person%5Bname%5D=Nicholas',
      :person => {:name => 'Nicholas', :login => 'seckar'}
  end

  def test_multiple_nested
    assert_query_equal 'account%5Bperson%5D%5Bid%5D=20&person%5Bid%5D=10',
      :person => {:id => 10}, :account => {:person => {:id => 20}}
  end

  def test_array_values
    assert_query_equal 'person%5Bid%5D%5B%5D=10&person%5Bid%5D%5B%5D=20',
      :person => {:id => [10, 20]}
  end

  def test_array_values_are_not_sorted
    assert_query_equal 'person%5Bid%5D%5B%5D=20&person%5Bid%5D%5B%5D=10',
      :person => {:id => [20, 10]}
  end

  def test_expansion_count_is_limited
    assert_raises RuntimeError do
      attack_xml = <<-EOT
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE member [
        <!ENTITY a "&b;&b;&b;&b;&b;&b;&b;&b;&b;&b;">
        <!ENTITY b "&c;&c;&c;&c;&c;&c;&c;&c;&c;&c;">
        <!ENTITY c "&d;&d;&d;&d;&d;&d;&d;&d;&d;&d;">
        <!ENTITY d "&e;&e;&e;&e;&e;&e;&e;&e;&e;&e;">
        <!ENTITY e "&f;&f;&f;&f;&f;&f;&f;&f;&f;&f;">
        <!ENTITY f "&g;&g;&g;&g;&g;&g;&g;&g;&g;&g;">
        <!ENTITY g "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx">
      ]>
      <member>
      &a;
      </member>
      EOT
      Hash.from_xml(attack_xml)
    end
  end

  private
    def assert_query_equal(expected, actual, message = nil)
      assert_equal expected.split('&'), actual.to_query.split('&')
    end
end
