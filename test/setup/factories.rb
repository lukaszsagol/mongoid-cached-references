require 'factory_girl'

Factory.sequence :name do |n|
  %w(lorem ipsum dolor sit amet enim
     suspendisse pellentesque dui
     nonfelis maecenas malesuada elit 
     lectus felis malesuada ultricies
     vestibulum commodo volutpat)[rand(21)]
end

Factory.define :text do |text|
  text.title  { Factory.next(:name) }
  text.length { rand(300) }
  text.author { Factory.next(:name) }
end

Factory.define :directory do |dir|
  dir.name { Factory.next :name }
end
