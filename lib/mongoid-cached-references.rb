require 'mongoid'
require 'mongoid/cached_references/class_methods'

module Mongoid
  module CachedReferences
    def self.included(klass)
      klass.extend Mongoid::CachedReferences::ClassMethods
    end
  end
end
