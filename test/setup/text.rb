class Text
  include Mongoid::Document
  include Mongoid::CachedReferences

  field :title
  field :length
  field :author

  cached_referenced_in :directory
end
