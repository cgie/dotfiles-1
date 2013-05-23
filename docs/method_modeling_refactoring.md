
# Method Modeling: A Refactoring

> by Matthew Parker
> Saturday, May 18, 2013

While working on _AwesomeResource_, I needed to implement functionality that would make the following test pass:

```ruby
  it "creates readers and writers for any attributes passed in during initialization" do
    article_class = Class.new do
      include AwesomeResource
    end

    article = article_class.new("title" => "Fun")
    article.title.should == "Fun"

    article.title = 'Fun Times!'
    article.title.should == 'Fun Times!'

    expect { article.unknown_attribute }.to raise_exception
  end  
```

Simple enough. If you initialize an instance of a class that includes AwesomeResource, then you get attribute readers and writers for any hash keys passed in during initialization.

My first attempt at implementation looked something like this:

```ruby
module AwesomeResource
  attr_reader :awesome_attributes

  def initialize(attributes={})
    @awesome_attributes = AwesomeResource::Attributes.new attributes
  end

  def method_missing(method_name, *args)
    if method_name["="]
      if awesome_attributes.has_key?(method_name[0...-1])
        awesome_attributes[method_name[0…-1]] = args.first
      else
        super
      end
    else
      if awesome_attributes.has_key?(method_name)
        awesome_attributes[method_name]
      else
        super
      end
    end
  end
end
```

Yuk. All those nested `if/else`'s didn't sit well with me. Let me try to clean that up:

```ruby
  def method_missing(method_name, *args)
    if method_name["="] && awesome_attributes.has_key?(method_name[0...-1])
      awesome_attributes[method_name[0...-1]] = args.first
    elsif awesome_attributes.has_key?(method_name)
      awesome_attributes[method_name]
    else
      super
    end
  end
```

The best I can say for this code is that it's more compact. But is it any more readable? Hardly. In fact it's worse.

Let's take another look at the first implementation. The nested `if/else` blocks look awfully similar. Perhaps there's a <i>polymorphic model</i> lurking there? But what are we modeling? If we were to wrap a class around those blocks, we'd have to be modeling a method. What would that look like? Let's extract some classes:

```ruby
  class AttributeWriter
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def call(attribute_name, attribute_value)
      raise "Unknown Attribute" unless attributes.has_key?(attribute_name)
      attributes[attribute_name] = attribute_value
    end
  end

  class AttributeReader
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def call(attribute_name)
      raise "Unknown Attribute" unless attributes.has_key?(attribute_name)
      attributes[attribute_name]
    end
  end

  def method_missing(method_name, *args)
    if method_name["="]
      AttributeWriter.new(awesome_attributes).call(method_name[0...-1], *args)
    else
      AttributeReader.new(awesome_attributes).call(method_name)
    end
  end
```

OK, I at least feel like I'm trying to write OO code at this point. There's a bit of duplication between the AttributeReader and AttributeWriter classes. We could clean that up with template methods:

```ruby
  class AttributeAccessor
    attr_reader :attributes, :attribute_name

    def initialize(attributes, attribute_name)
      @attribute_name = attribute_name
      @attributes = attributes
    end

    def call(*args)
      raise "Unknown Attribute" unless attributes.has_key?(attribute_name)
      execute(*args)
    end

    def execute(*)
    end
  end

  class AttributeWriter < AttributeAccessor
    def attribute_name
      super[0...-1]
    end
    
    def execute(attribute_value)
      attributes[attribute_name] = attribute_value
    end
  end

  class AttributeReader < AttributeAccessor
    def execute
      attributes[attribute_name]
    end
  end

  def method_missing(method_name, *args)
    if method_name["="]
      AttributeWriter.new(awesome_attributes, method_name).call(*args)
    else
      AttributeReader.new(awesome_attributes, method_name).call
    end
  end
```

Notice that we've moved the responsibility of stripping off the `=` off the method_name from `method_missing` down into `AttributeWriter`.

Hmmm... The base class is pretty abstract. How easy it this code to understand now?

Also, the body of the `method_missing` now looks a lot like a factory method. While in Rome...

```ruby
  class AttributeAccessor
    attr_reader :attributes, :attribute_name

    def self.from_method_name(attributes, method_name)
      if method_name["="]
        AttributeWriter.new(attributes, method_name)
      else
        AttributeReader.new(attributes, method_name)
      end
    end

    def initialize(attributes, attribute_name)
      @attribute_name = attribute_name
      @attributes = attributes
    end

    def call(*args)
      raise "Unknown Attribute" unless attributes.has_key?(attribute_name)
      execute(*args)
    end

    def execute(*)
    end
  end

  class AttributeWriter < AttributeAccessor
    def attribute_name
      super[0...-1]
    end

    def execute(attribute_value)
      attributes[attribute_name] = attribute_value
    end
  end

  class AttributeReader < AttributeAccessor
    def execute
      attributes[attribute_name]
    end
  end

  def method_missing(method_name, *args)
    AttributeAccessor.from_method_name(awesome_attributes, method_name).call(*args)
  end
```

I'm now starting to question this code. Is there a good trade off here between indirection and maintainability? I don't think the number of accessors are likely to grow (accessors have consisted solely of getters and setters since the dawn of OO). Between all of the refactorings, I think the first (with its minor duplication) was the easiest to understand.

Yet something still doesn't feel right. Let's look back at the very first code snippet. Notice the `AwesomeResource::Attributes.new` in the `initialization` method? Those are our bag of attributes (they're basically a hash with indifferent access). We keep passing it around to all of our Attribute* classes… perhaps some of this code should have lived there in the first place?

```ruby
module AwesomeResource
  attr_reader :awesome_attributes

  def initialize(attributes={})
    @awesome_attributes = AwesomeResource::Attributes.new attributes
  end

  def method_missing(method_name, *args)
    awesome_attributes.accessor_for_method_name(method_name).call(*args)
  end
end

module AwesomeResource
  class Attributes < SimpleDelegator
	#...

    def accessor_for_method_name(method_name)
      if method_name["="]
        ->(attribute_value) { self[method_name[0...-1]] = attribute_value }
      else
        -> { self[method_name] }
      end
    end

    def [](key)
      validate_key_exists(key)
      attributes[standardized_key(key)]
    end

    def []=(key, value)
      validate_key_exists(key)
      attributes[standardized_key(key)] = value
    end

    private
    def validate_key_exists(key)
      raise "Unknown attribute" unless has_key? key
    end
    
    #...
  end
end
```

This feels right. We're now modeling methods with lambdas (Ruby's built in method objects). We've eliminated a tangle of nested if/else blocks without introducing too much indirection. We've maintained high-cohesion within the `AwesomeResource::Attributes` class despite the new methods.

http://pivotallabs.com/method-modeling-a-refactoring/
http://pivotallabs.com/author/mparker/