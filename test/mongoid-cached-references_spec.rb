require 'helper'

describe 'cached_references_many in directory' do
  after do
    Mongoid.database.collections.each { |coll| coll.remove }
  end

  before do
    @directory = Factory :directory
    @text      = Factory :text
    @text2     = Factory :text
    @directory.add_text @text

  end

  describe 'when adding new text' do
    it 'must create text if attributes provided' do
      count_before = Text.count

      @directory.add_text Factory.attributes_for(:text)

      count_before.wont_equal Text.count
    end

    it 'won\'t create text if Text object provided' do
      count_before = Text.count

      @directory.add_text @text2

      count_before.must_equal Text.count
    end

    it 'won\'t add to cache if Text already cached' do
      cache = @directory.text_cache

      @directory.add_text @text

      cache.must_equal @directory.text_cache
    end

    it 'must add cached fields to directory' do
      @directory.add_text @text
      @directory.text_cache.last do |text|
        @text.attributes.each do |attr|
          text[attr].must_equal attr
        end
      end
    end

    it 'must store directory_id in file' do
      @directory.add_text @text
      @text.cached_in_directory_id.must_equal @directory._id
    end

    it 'won\'t cache not defined fields' do
      @directory.text_cache.last do |text|
        @text.wont_include? :author
      end

    end
  end

  describe 'when removing referenced text' do
    it 'must remove Text object' do
      count_before = Text.count

      @directory.remove_text @text._id

      count_before.wont_equal Text.count
    end

    it 'must removed cached fields' do
      @directory.remove_text @text._id
      @directory.text_cache.must_be_empty
    end
  end
end

