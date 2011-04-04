module Mongoid
  module CachedReferences
    module ClassMethods
      def cached_referenced_in(relation)
        related_class = relation.to_s.camelize.constantize
        related_single = relation.to_s
        self_single = self.to_s.downcase
        field_name = "cached_in_#{related_single}_id"

        class_eval do
          field field_name, :default => nil
          before_update "reload_cached_reference_in_#{related_single}"

          define_method "reload_cached_reference_in_#{related_single}" do
            if obj = related_class.find(:first, :conditions => {:_id => self["cached_in_#{related_single}_id"]})
              obj.send("update_cached_#{self_single}", self, false)
            else
              # object not cached anywhere
            end
          end

          define_method "update_cached_in_#{related_single}_id" do |obj, save|
            if self[field_name] != obj.id
              self[field_name] = obj.id
              self.save if save
            end
          end
        end
      end

      def cached_references_many(relation, opts = {})
        fields = opts[:fields]
        related_class = relation.to_s.singularize.camelize.constantize
        related_single = relation.to_s.singularize
        related_multi = relation.to_s

        self_single = self.to_s.downcase.dasherize

        class_eval do
          const_set "#{related_single.upcase}_CACHE_FIELDS", fields
          field "#{related_single}_cache", :default => []

          define_method "add_#{related_single}" do |obj|
            if obj.is_a? Hash
              obj = related_class.new obj
            end

            send("update_cached_#{related_single}", obj, true)
          end

          define_method "remove_#{related_single}" do |id|
            if (obj = related_class.find(:first, :conditions => {:_id => id}))
              send("remove_cached_#{related_single}", id)
              obj.delete
              self.save
            end
          end

          define_method "update_cached_#{related_single}" do |obj, save_cached|
            send("remove_cached_#{related_single}", obj.id)

            cache_hash = Hash[self.class.const_get("#{related_single.upcase}_CACHE_FIELDS").collect { |field| [field.to_sym, obj[field]] }]
            self["#{related_single}_cache"] << cache_hash.merge(:id => obj.id)

            obj.send("update_cached_in_#{self_single}_id", self, save_cached)
            self.save
          end

          define_method "remove_cached_#{related_single}" do |id|
            self["#{related_single}_cache"].delete_if { |tc| tc[:id] == id }
          end

          define_method "find_cached_#{related_single}" do |id|
            self["#{related_single}_cache"].select { |tc| tc[:id] == id }
          end
        end
      end
    end
  end
end
