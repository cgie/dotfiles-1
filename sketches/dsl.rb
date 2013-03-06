
module DSL

  def self.included(base)
    base.exdends ClassMethods
    ancestor_paginater_class = base.ancestors.detect do |a|
      a.paginater_class if a.respond_to?(:paginater_class)
    end
    base.const_set(:Paginater, Class.new(ancestor_paginater_class || Grape::Paginater)) unless const_defined?(:Paginater)
  end

  module ClassMethods

    def paginater_class(search_ancestors = true)
      klass = const_get(:Paginater) if cont_defined?(:Paginater)
      klass ||= ancestors.detect do |a|
        a.paginater_class(false) if a.respond_to(:paginater_class)
      end if search_ancestors
      klass
    end

    def paginater(*paginatures, &block)
      paginater_class.page *paginatures if paginatures.any?
      paginater_class.class_eval(&block) if block_given?
      paginater_class
    end

  end # ClassMethods

end # DSL
