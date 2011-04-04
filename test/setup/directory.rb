class Directory
  include Mongoid::Document
  include Mongoid::CachedReferences
  field :name

  cached_references_many :texts, :fields => [:title, :length]
end
