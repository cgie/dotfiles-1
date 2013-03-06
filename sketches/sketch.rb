module Paginater

  module PageScopeMethods

    # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
    # Model.page(3).per(10)
    def per(num)
      if num.nil?
        limit(nil).offset(0)
      elsif (n = num.to_i) <= 0
        self
      elsif max_per_page && max_per_page < n
        limit(max_per_page).offset(offset_value / limit_value * max_per_page)
      else
        limit(n).offset(offset_value / limit_value * n)
      end
    end

    def padding(num)
      offset(offset_value + num.to_i)
    end

    def total_pages
      return 1 if limit_value.nil?

      total_pages_count = (total_count.to_f / limit_value).ceil
      if max_pages.present? && max_pages < total_pages_count
        max_pages
      else
        total_pages_count
      end
    end

    def current_page
      return 1 if limit_value.nil?
      (offset_value / limit_value) + 1
    end

    def first_page?
      current_page == 1
    end

    def last_page?
      current_page >= total_pages
    end

  end #PageScopeMethods

  module ConfigurationMethods
    
    module ClassMethods

      def paginates_per(val)
        @_default_per_page = val
      end

      def default_per_page
        @_default_per_page || Constants::DefaultPerPage
      end

      def max_paginates_per(val)
        @_max_per_page = val
      end

      def max_per_page
        @_max_per_page || Constants::MaxPerPage
      end

      def max_pages_per(val)
        @_max_pages = val
      end

      def max_pages
        @_max_pages || Constants::MaxPages
      end
    end
  end
end

module Paginater
  # Kind of Array that can paginate
  class PaginatableArray < Array
    include Paginater::ConfigurationMethods::ClassMethods

    attr_internal_accessor :limit_value, :offset_value

    # ==== Options
    # * <tt>:limit</tt> - limit
    # * <tt>:offset</tt> - offset
    # * <tt>:total_count</tt> - total_count
    def initialize(original_array = [], options = {})
      @_original_array, @_limit_value, @_offset_value, @_total_count = original_array, (options[:limit] || default_per_page).to_i, options[:offset].to_i, options[:total_count]

      if options[:limit] && options[:offset]
        extend Paginater::PageScopeMethods
      end

      if options[:total_count]
        super original_array
      else
        super(original_array[@_offset_value, @_limit_value] || [])
      end
    end

    # items at the specified "page"
    # def #{Paginater.config.page_method_name}(num = 1)
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
def page(num = 1)
offset(limit_value * ([num.to_i, 1].max - 1))
end
RUBY

    # returns another chunk of the original array
    def limit(num)
      self.class.new @_original_array, :limit => num, :offset => @_offset_value, :total_count => @_total_count
    end

    # total item numbers of the original array
    def total_count
      @_total_count || @_original_array.count
    end

    # returns another chunk of the original array
    def offset(num)
      self.class.new @_original_array, :limit => @_limit_value, :offset => num, :total_count => @_total_count
    end
  end

  # Wrap an Array object to make it paginatable
  # ==== Options
  # * <tt>:limit</tt> - limit
  # * <tt>:offset</tt> - offset
  # * <tt>:total_count</tt> - total_count
  def self.paginate_array(array, options = {})
    PaginatableArray.new array, options
  end
end



module Grape

  class Paginater

    attr_reader :object, :options


    def paginater
      self.class.paginater_class.new(self)
    end
  
    def self.page(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}

      if args.size > 1
        raise ArgumentError, "You may not use the :as option on multi-attribute paginatures." if options[:as]
        raise ArgumentError, "You may not use block-setting on multi-attribute paginatures." if block_given?
      end

      raise ArgumentError, "You may not use block-setting when also using format_with" if block_given? && options[:format_with].respond_to?(:call)

      options[:proc] = block if block_given?

      args.each do |attribute|
        paginatures[attribute.to_sym] = options
      end
    end
    def self.paginatures
      @paginatures ||= {}
      if superclass.respond_to? :paginatures
        @paginatures = superclass.exposures.merge(@paginatures)
      end
      @paginatures
    end

    def initialize(object, options = {})
      @object, @options = object, options
    end

    def paginatures
      self.class.paginatures
    end

    def serializable_hash(runtime_options = {})
      return nil if object.nil?
      opts = options.merge(runtime_options || {})
      exposures.inject({}) do |output, (attribute, exposure_options)|
        if (exposure_options.has_key?(:proc) || object.respond_to?(attribute)) && conditions_met?(exposure_options, opts)
          partial_output = value_for(attribute, opts)
          output[key_for(attribute)] =
            if partial_output.respond_to? :serializable_hash
              partial_output.serializable_hash(runtime_options)
            elsif partial_output.kind_of?(Array) && !partial_output.map {|o| o.respond_to? :serializable_hash}.include?(false)
              partial_output.map {|o| o.serializable_hash}
            else
              partial_output
            end
        end
        output
      end
    end

    alias :as_json :serializable_hash

    def to_json(options = {})
      options = options.to_h if options && options.respond_to?(:to_h)
      MultiJson.dump(serializable_hash(options))
    end

    def to_xml(options = {})
      options = options.to_h if options && options.respond_to?(:to_h)
      serializable_hash(options).to_xml(options)
    end

  end # Paginater
end # Grape

