module Permalink
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def generate_permalink_from(column, options = {})      
      class_attribute :permalink_options
      self.permalink_options ||= {}
      self.permalink_options[:column] = column.to_s
      empty_errors = {:if => proc{|m| m.errors[column].empty?}}
      
      before_validation :generate_permalink
      validates_presence_of :permalink, empty_errors
      validates_uniqueness_of :permalink, (options[:uniqueness] || {}).merge(empty_errors)
      
      include Permalink::InstanceMethods
    end
  end
  
  module InstanceMethods
    def to_param; permalink; end
    
    protected
  
    def generate_permalink
      self.permalink = (permalink.blank? ? send(permalink_options[:column]) : permalink).to_s.parameterize
    end
  end
  
end

ActiveRecord::Base.send(:include, Permalink)
